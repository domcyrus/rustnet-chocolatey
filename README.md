# RustNet Chocolatey Package

This repository contains the Chocolatey package for [RustNet](https://github.com/domcyrus/rustnet), a network monitoring TUI application.

## Installation

```powershell
# Once published to Chocolatey Community Repository
choco install rustnet

# Or install from source
git clone https://github.com/domcyrus/rustnet-chocolatey
cd rustnet-chocolatey
choco pack
choco install rustnet -source . -y
```

## Requirements

- Windows 10/11
- Administrator privileges (for packet capture)
- Npcap (automatically installed as dependency)

## Building from Source

1. Clone this repository
2. Update version in `rustnet.nuspec`
3. Update checksums in `tools/chocolateyinstall.ps1` and `tools/VERIFICATION.txt`
4. Run `choco pack`

### Updating to a New Version

Use the provided PowerShell script to update the package:

```powershell
# Calculate checksum for the new release
$checksum = (Get-FileHash -Algorithm SHA256 rustnet-x86_64-pc-windows-msvc.zip).Hash

# Update all files with new version and checksum
.\update-checksums.ps1 -Version "0.2.0" -Checksum $checksum

# Test the package locally
choco pack
choco install rustnet -source . -y
```

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

## Publishing

The package is automatically published to Chocolatey when a new release is created in the main RustNet repository.

## License

Apache License 2.0
