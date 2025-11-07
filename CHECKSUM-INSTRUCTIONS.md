# How to Update Checksums

Before publishing this Chocolatey package, you need to calculate and update the SHA256 checksum for the release binary.

## Quick Steps

1. Download the release binary:
   ```powershell
   Invoke-WebRequest -Uri "https://github.com/domcyrus/rustnet/releases/download/v0.15.0/rustnet-v0.15.0-x86_64-pc-windows-msvc.zip" -OutFile "rustnet.zip"
   ```

2. Calculate the SHA256 checksum:
   ```powershell
   $checksum = (Get-FileHash -Algorithm SHA256 rustnet.zip).Hash
   Write-Host "Checksum: $checksum"
   ```

3. Update the package using the helper script:
   ```powershell
   .\update-checksums.ps1 -Version "0.15.0" -Checksum $checksum
   ```

   Or manually replace `TODO_UPDATE_CHECKSUM` in these files:
   - `tools/chocolateyinstall.ps1`
   - `tools/VERIFICATION.txt`

## Testing Locally

After updating the checksum:

```powershell
# Build the package
choco pack

# Install locally for testing
choco install rustnet -source . -y --force

# Test the application
rustnet --help

# Uninstall
choco uninstall rustnet -y
```

## Publishing to Chocolatey

```powershell
# Push to Chocolatey Community Repository
choco push rustnet.0.15.0.nupkg --source https://push.chocolatey.org/
```
