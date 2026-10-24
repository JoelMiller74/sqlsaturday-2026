# Developer Tool Setup

This repository uses PowerShell-based setup automation and relies on additional modern CLI tools.

## Why these tools are needed

### PowerShell

- Standard shell and scripting environment for Windows automation.
- PowerShell 7 receives active security and feature updates.

### uvx

- Runs Python tools in isolated environments without manual virtual environment setup.
- Ideal for repeatable developer tooling and clean dependency execution.

### npx

- Runs Node.js CLI tools on demand, including local project executables.
- Avoids global installs for many JavaScript tooling tasks.

### dab (Data API builder)

- Builds secure REST and GraphQL endpoints over SQL and Cosmos DB data sources.
- Supports local development and API configuration validation workflows.
- Requires .NET 8 for the CLI.
- Installed as a one-off global .NET tool (`Microsoft.DataApiBuilder`) after `.NET SDK 8` is installed.

## Why the recommended VS Code extensions are needed

- `ms-vscode.powershell`: PowerShell syntax, diagnostics, and debugging.
- `ms-python.python`: Python language support used with uv and uvx workflows.
- `dbaeumer.vscode-eslint`: JavaScript and TypeScript linting support for Node and npx-based tooling.
- `jerry-nixon.omnibus-data-api-builder`: Data API builder focused authoring tools.

## Install latest tools

Run the installer script from a PowerShell terminal:

```powershell
./install-software.ps1
```

For expert-demo machines (adds DataFactory MCP prerequisites automatically):

```powershell
./install-software.ps1 -InstallExpertDemoPrerequisites
```

Important: start PowerShell as Administrator when possible for the smoothest install experience.

If the script is started from a non-admin terminal, it attempts to relaunch itself with elevation and shows a UAC prompt. If elevation is canceled or fails, the script exits with an error.

## Customize installed software

Installed software is defined in `install-software.packages.json`.

- Add or remove package IDs in `wingetPackages` to control which `winget` packages are installed or upgraded.

The script loops through `wingetPackages` and runs a generic install-or-upgrade flow. It does not include per-package custom verification logic.

After the package loop, the script reloads PATH from machine and user values, then installs or updates DAB as a one-off using:

```powershell
dotnet tool update --global Microsoft.DataApiBuilder
```

and falls back to:

```powershell
dotnet tool install --global Microsoft.DataApiBuilder
```

When `-InstallExpertDemoPrerequisites` is supplied, the script also:

- Installs or upgrades `.NET SDK 10` (`Microsoft.DotNet.SDK.10`) via winget.
- Installs or updates `Microsoft.DataFactory.MCP` as a global dotnet tool.

## VS Code extension recommendations

This repository does not auto-install VS Code extensions.

Recommended extensions are defined in `.vscode/extensions.json`. When the folder is opened in VS Code, you are prompted to install recommended extensions and can choose which ones to install.

## Verify installation

```powershell
pwsh -v
dotnet --list-sdks
uvx --version
npx --version
dab --version
```

## MCP local server prerequisites

### Demo profile (`.mcp.json`)

This is the main demo profile and uses remote MCP servers only.

No additional package installs are required for MCP server startup in this profile.

### Examples profile (`.mcp.expert.json`)

This profile is local/examples-focused and avoids local/remote duplicates in the same file.

No additional installs are required beyond this script's software list:

- `OpenJS.NodeJS` provides `npx`
- `astral-sh.uv` provides `uvx`

The configured local servers are launched through `npx`/`uvx`, which download their referenced packages automatically when first used.

Optional prefetch for smoother local demonstrations:

```powershell
npx -y @microsoft/fabric-mcp@latest --help
npx -y @microsoft/powerbi-modeling-mcp@latest --help
uvx microsoft-fabric-rti-mcp --help
```

Optional add-on (not in `.mcp.expert.json` by default): `DataFactory MCP (Local)` (`datafactorymcp`) requires an extra .NET tool install:

```powershell
dotnet tool install --global Microsoft.DataFactory.MCP
```

You can automate this with:

```powershell
./install-software.ps1 -InstallExpertDemoPrerequisites
```

Update if already installed:

```powershell
dotnet tool update --global Microsoft.DataFactory.MCP
```

Important: DataFactory MCP documentation indicates a newer .NET SDK requirement than the base `.NET SDK 8` installed for DAB. Verify users have the .NET SDK version required by their DataFactory MCP tool version.

If a command is not found immediately after install, open a new terminal and run the command again so the refreshed PATH is loaded.

The script also refreshes the current process PATH at the end by merging machine PATH, user PATH, and the current process PATH.
