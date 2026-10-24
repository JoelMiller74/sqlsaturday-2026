[CmdletBinding()]
param(
    [switch]$InstallExpertDemoPrerequisites
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$wingetNoOpExitCode = -1978335189
$expertDotnetSdkPackageId = "Microsoft.DotNet.SDK.10"
$configPath = Join-Path $PSScriptRoot "install-software.packages.json"

function Install-WingetPackage {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$PackageId
    )

    $normalizedPackageId = $PackageId.Trim()
    if ([string]::IsNullOrWhiteSpace($normalizedPackageId)) {
        throw "Each winget package entry must contain a package id string."
    }

    $wingetArgs = @(
        "install"
        "--id", $normalizedPackageId
        "-e"
        "--source", "winget"
        "--accept-package-agreements"
        "--accept-source-agreements"
    )

    Write-Host "Installing or upgrading $normalizedPackageId..." -ForegroundColor Cyan
    Write-Host "Running: winget $($wingetArgs -join ' ')" -ForegroundColor Cyan
    & winget @wingetArgs | Out-Host
    [int]$exitCode = $LASTEXITCODE

    if ($exitCode -ne 0 -and $exitCode -ne $wingetNoOpExitCode) {
        throw "Failed to install or upgrade $normalizedPackageId. winget exit code: $exitCode"
    }
}

function Install-OrUpdateDotnetTool {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$PackageId
    )

    $tools = dotnet tool list --global | Out-String
    if ($tools -match [Regex]::Escape($PackageId)) {
        Write-Host "Updating dotnet global tool $PackageId..." -ForegroundColor Cyan
        dotnet tool update --global $PackageId | Out-Host
    }
    else {
        Write-Host "Installing dotnet global tool $PackageId..." -ForegroundColor Cyan
        dotnet tool install --global $PackageId | Out-Host
    }

    [int]$exitCode = $LASTEXITCODE
    if ($exitCode -ne 0) {
        throw "Failed to install or update dotnet global tool $PackageId. dotnet exit code: $exitCode"
    }
}

$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator
)

if (-not $isAdmin) {
    if (-not (Test-Path -LiteralPath $PSCommandPath)) {
        throw "Unable to determine the current script path for elevation."
    }

    $shellCommand = Get-Command pwsh -ErrorAction SilentlyContinue
    if (-not $shellCommand) {
        $shellCommand = Get-Command powershell -ErrorAction SilentlyContinue
    }
    if (-not $shellCommand) {
        throw "Unable to find a PowerShell host executable (pwsh or powershell)."
    }

    Write-Warning "Not running as Administrator. Attempting elevation via UAC prompt..."

    $elevationArgs = @("-NoProfile", "-ExecutionPolicy", "Bypass", "-File", "`"$PSCommandPath`"")
    foreach ($boundParameter in $PSBoundParameters.GetEnumerator()) {
        if ($boundParameter.Value -is [System.Management.Automation.SwitchParameter]) {
            if ($boundParameter.Value.IsPresent) {
                $elevationArgs += "-$($boundParameter.Key)"
            }
        }
        else {
            $elevationArgs += "-$($boundParameter.Key)"
            $elevationArgs += "$($boundParameter.Value)"
        }
    }

    try {
        $elevatedProcess = Start-Process -FilePath $shellCommand.Source -ArgumentList $elevationArgs -Verb RunAs -PassThru -Wait
        exit $elevatedProcess.ExitCode
    }
    catch {
        throw "Administrator rights are required. Elevation was canceled or failed: $($_.Exception.Message)"
    }
}

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    throw "winget is required but was not found. Install App Installer from Microsoft Store, then run this script again."
}

if (-not (Test-Path -LiteralPath $configPath)) {
    throw "Install configuration file not found: $configPath"
}

$configText = Get-Content -LiteralPath $configPath -Raw
if ([string]::IsNullOrWhiteSpace($configText)) {
    throw "Install configuration file is empty: $configPath"
}

$config = $configText | ConvertFrom-Json
if (-not $config.wingetPackages -or $config.wingetPackages.Count -eq 0) {
    throw "Install configuration must include at least one winget package in 'wingetPackages'."
}

foreach ($package in $config.wingetPackages) {
    Install-WingetPackage -PackageId ($package.ToString())
}

if ($InstallExpertDemoPrerequisites) {
    Write-Host "Installing expert-demo prerequisites..." -ForegroundColor Cyan
    Install-WingetPackage -PackageId $expertDotnetSdkPackageId
}

Write-Host "Refreshing System and User Paths..." -ForegroundColor Cyan
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User") 

if (Get-Command dotnet -ErrorAction SilentlyContinue) {
    Install-OrUpdateDotnetTool -PackageId "Microsoft.DataApiBuilder"

    if ($InstallExpertDemoPrerequisites) {
        Install-OrUpdateDotnetTool -PackageId "Microsoft.DataFactory.MCP"
    }
}
elseif ($InstallExpertDemoPrerequisites) {
    throw "dotnet was not found after installation. It is required for Data API Builder and DataFactory MCP expert prerequisites."
}
else {
    Write-Warning "dotnet was not found after installation. Skipping Data API Builder install/update."
}

Write-Host "Setup complete." -ForegroundColor Green
