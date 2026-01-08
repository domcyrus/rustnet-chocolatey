# RustNet Chocolatey Package

This repository contains the Chocolatey package for [RustNet](https://github.com/domcyrus/rustnet), a network monitoring TUI application.

## Installation

### Step 1: Install Npcap Runtime (Required)

Before installing RustNet, you must install Npcap Runtime for packet capture:

1. Download the Npcap installer (e.g., `npcap-1.84.exe`) from https://npcap.com/dist/
2. Run the installer
3. **Important**: Select **"WinPcap API compatible mode"** during installation

**Note**: Download the Npcap runtime installer, NOT the SDK. The SDK is only needed for building software.

### Step 2: Install RustNet

**Note**: Chocolatey installation commands must be run from an elevated PowerShell or Command Prompt. To open as Administrator:
- Press `Win + X` and select "Windows PowerShell (Admin)" or "Terminal (Admin)"
- Or right-click PowerShell/Command Prompt in Start Menu → "Run as Administrator"

```powershell
# Install from Chocolatey Community Repository
choco install rustnet

# Or install from source
git clone https://github.com/domcyrus/rustnet-chocolatey
cd rustnet-chocolatey
choco pack
choco install rustnet -source . -y
```

### Step 3: Run RustNet

```powershell
# Run from Command Prompt or PowerShell
rustnet

# Note: Depending on your Npcap installation settings, you may or may not need
# Administrator privileges. If you didn't select the option to restrict packet
# capture to administrators during Npcap installation, RustNet can run with
# normal user privileges.
```

## Troubleshooting

### "Unable to obtain lock file access" or "Access denied" errors

If you encounter errors about lock file access or "access denied to lib-bad" during installation:

**Cause**: These errors occur when Chocolatey commands are run without administrator privileges.

**Solution**:
1. Ensure you're running PowerShell/Command Prompt as Administrator (see Step 2 above)
2. If you previously had a failed installation, clean up any stale lock files:
   ```powershell
   # Run as Administrator
   Remove-Item "C:\ProgramData\chocolatey\lib\*" -Include "*.lock" -Force -ErrorAction SilentlyContinue
   Remove-Item "C:\ProgramData\chocolatey\lib-bad" -Force -Recurse -ErrorAction SilentlyContinue
   ```
3. Retry the installation with admin privileges

**Why admin rights are needed**: Chocolatey installs packages to `C:\ProgramData\chocolatey\`, which is a system-protected directory that requires administrator privileges to modify.

## Requirements

- Windows 10/11
- Npcap installed in WinPcap API compatible mode
- Administrator privileges (depending on Npcap configuration)

## Package Structure

```
rustnet-chocolatey/
├── rustnet.nuspec              # Package specification
├── tools/
│   ├── chocolateyinstall.ps1   # Installation script
│   └── chocolateyuninstall.ps1 # Uninstallation script
├── .github/workflows/
│   ├── update-package.yml      # Automated package updates
│   └── publish-package.yml     # Manual publish to Chocolatey
└── README.md
```

## Automated Workflows

This repository includes GitHub Actions workflows that automate package maintenance:

- **Automatic Updates**: Triggered by the main RustNet release workflow
- **Manual Updates**: Can be triggered with a specific version
- **Publishing**: Can publish to Chocolatey Community Repository

See [.github/workflows/README.md](.github/workflows/README.md) for details.

### Manual Package Update

To manually update to a specific version:

```bash
# Trigger via GitHub Actions
gh workflow run update-package.yml -f version=0.19.0

# Update and publish in one step
gh workflow run update-package.yml -f version=0.19.0 -f publish=true

# Or use the GitHub UI: Actions → Update Chocolatey Package → Run workflow
```

## Publishing

The package can be published to Chocolatey in two ways:

1. **During update**: Set `publish=true` when triggering the update workflow
2. **Separately**: Use the publish workflow after updating

**Setup for publishing:**
1. Add `CHOCO_API_KEY` to repository secrets
2. Get your API key from: https://community.chocolatey.org/account

## Required Secrets

| Secret | Repository | Purpose |
|--------|-----------|---------|
| `CHOCOLATEY_PAT` | domcyrus/rustnet | Trigger updates from main release |
| `CHOCO_API_KEY` | This repo | Publish to Chocolatey Community |

## License

Apache License 2.0
