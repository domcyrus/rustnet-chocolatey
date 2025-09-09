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
3. Update checksums in `tools/chocolateyinstall.ps1`
4. Run `choco pack`

## Publishing

The package is automatically published to Chocolatey when a new release is created in the main RustNet repository.

## License

Apache License 2.0
