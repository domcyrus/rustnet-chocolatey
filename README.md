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

```powershell
# Once published to Chocolatey Community Repository
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

## Requirements

- Windows 10/11
- Npcap installed in WinPcap API compatible mode
- Administrator privileges (depending on Npcap configuration)

## Building from Source

**IMPORTANT**: Before building, you must update the SHA256 checksum. See [CHECKSUM-INSTRUCTIONS.md](CHECKSUM-INSTRUCTIONS.md) for details.

1. Clone this repository
2. Download the release binary and calculate its SHA256 checksum
3. Update the checksum using the helper script or manually
4. Run `choco pack` to build the package

### Updating to a New Version

```powershell
# 1. Download the release binary
Invoke-WebRequest -Uri "https://github.com/domcyrus/rustnet/releases/download/v0.15.0/rustnet-v0.15.0-x86_64-pc-windows-msvc.zip" -OutFile "rustnet.zip"

# 2. Calculate checksum
$checksum = (Get-FileHash -Algorithm SHA256 rustnet.zip).Hash

# 3. Update all files with new version and checksum
.\update-checksums.ps1 -Version "0.15.0" -Checksum $checksum

# 4. Test the package locally
choco pack
choco install rustnet -source . -y
```

For detailed instructions, see [CHECKSUM-INSTRUCTIONS.md](CHECKSUM-INSTRUCTIONS.md).

## Package Structure

```
rustnet-chocolatey/
├── rustnet.nuspec              # Package specification
├── tools/
│   ├── chocolateyinstall.ps1   # Installation script
│   ├── chocolateyuninstall.ps1 # Uninstallation script
│   └── VERIFICATION.txt        # Package verification info
├── update-checksums.ps1        # Helper script for updates
└── README.md
```

## Automated Workflows

This repository includes GitHub Actions workflows that automate package maintenance:

- **Daily Release Checks**: Automatically detects new RustNet releases
- **Automated Updates**: Downloads binaries, calculates checksums, and creates PRs
- **Automated Publishing**: Publishes to Chocolatey Community Repository on release

See [.github/workflows/README.md](.github/workflows/README.md) for details.

### Manual Package Update

To manually update to a specific version:

```bash
# Trigger via GitHub Actions
gh workflow run update-package.yml -f version=0.16.0

# Or use the GitHub UI: Actions → Update RustNet Package → Run workflow
```

## Publishing

The package is automatically published to Chocolatey when a GitHub release is created in this repository.

**Setup for automatic publishing:**
1. Add `CHOCO_API_KEY` to repository secrets
2. Get your API key from: https://community.chocolatey.org/account
3. Create a release → Package publishes automatically

## License

Apache License 2.0
