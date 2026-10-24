# SQL Saturday 2026 - Supercharge Microsoft Fabric with MCP

Content for SQL Saturday 2026 Event - Supercharge Microsoft Fabric with MCP.

## Developer setup

Run the setup script from PowerShell:

```powershell
./install-software.ps1
```

For expert-demo machines (installs extra DataFactory MCP prerequisites):

```powershell
./install-software.ps1 -InstallExpertDemoPrerequisites
```

The script:

- Ensures elevation (UAC prompt if needed).
- Reads package IDs from `install-software.packages.json`.
- Installs or upgrades each package with `winget install --id <package> -e`.
- Optionally installs expert-demo prerequisites when `-InstallExpertDemoPrerequisites` is provided.
- Refreshes the current process PATH from machine/user PATH values.
- Installs or updates Data API Builder (`Microsoft.DataApiBuilder`) via `dotnet tool`.

## Software package list

Edit `install-software.packages.json` to control installed software.

Example:

```json
{
	"wingetPackages": [
		"Microsoft.PowerShell",
		"astral-sh.uv",
		"OpenJS.NodeJS",
		"Microsoft.DotNet.SDK.8"
	]
}
```

Add or remove package IDs in `wingetPackages` and rerun `./install-software.ps1`.

## VS Code extensions

This repo uses extension recommendations only (no forced extension install in the setup script).

Recommended extensions are listed in `.vscode/extensions.json`.

## MCP package requirements

### `.mcp.json` (main demo profile: remote mode)

This is the file to use during the live demo.

- Remote servers only.
- No duplicate local/remote tool families in the same file.
- No extra package installs required for MCP beyond normal sign-in and permissions.

#### What `(Global)` means in `.mcp.json`

`(Global)` is a naming label used in this repo, not a third connection mode.

- `Local` means a server started on your machine (typically `stdio` via `npx` or `uvx`).
- `Remote` means a hosted HTTP MCP endpoint.
- `(Global)` entries are still `Remote` HTTP endpoints. The label indicates a shared Fabric data-plane endpoint that can work across multiple Fabric SQL/KQL-capable item types.

Practical rule: treat `(Global)` as "remote shared endpoint," not as a separate install type.

### `.mcp.expert.json` (examples profile: local mode)

This file is for showing local alternatives and advanced examples.

It uses `npx` and `uvx` from software already installed by `./install-software.ps1`:

- `npx` from `OpenJS.NodeJS`
- `uvx` from `astral-sh.uv`

Optional prefetch (to reduce first-run delay when demonstrating local servers):

```powershell
npx -y @microsoft/fabric-mcp@latest --help
npx -y @microsoft/powerbi-modeling-mcp@latest --help
uvx microsoft-fabric-rti-mcp --help
```

Optional add-on (not in `.mcp.expert.json` by default): DataFactory MCP local server.

Install manually:

```powershell
dotnet tool install --global Microsoft.DataFactory.MCP
```

or let the setup script do it:

```powershell
./install-software.ps1 -InstallExpertDemoPrerequisites
```

If needed, update it with:

```powershell
dotnet tool update --global Microsoft.DataFactory.MCP
```

Note: DataFactory MCP documentation calls out a newer .NET SDK requirement than the base `.NET 8` used for DAB.

## Presentation script

1. Open main profile and demo.
2. Open expert profile and explain local alternatives.
3. Mention optional DataFactory add-on command: `dotnet tool install --global Microsoft.DataFactory.MCP`.
