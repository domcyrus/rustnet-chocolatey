$ErrorActionPreference = 'Stop'

$packageName = 'rustnet'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64 = 'https://github.com/domcyrus/rustnet/releases/download/v0.1.0/rustnet-x86_64-pc-windows-msvc.zip'
$checksum64 = 'CHECKSUM_PLACEHOLDER'
$checksumType64 = 'sha256'

$packageArgs = @{
  packageName    = $packageName
  unzipLocation  = $toolsDir
  url64bit       = $url64
  checksum64     = $checksum64
  checksumType64 = $checksumType64
}

# Download and extract the archive
Install-ChocolateyZipPackage @packageArgs

# Create a shim for the executable
$exePath = Join-Path $toolsDir 'rustnet.exe'

# Verify the executable exists
if (-not (Test-Path $exePath)) {
  throw "RustNet executable not found at $exePath"
}

Write-Host "RustNet has been installed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "IMPORTANT: RustNet requires administrator privileges to capture network packets." -ForegroundColor Yellow
Write-Host "Run 'rustnet' from an elevated command prompt to use the application." -ForegroundColor Yellow
Write-Host ""
Write-Host "Note: Npcap is required for packet capture and is installed as a dependency." -ForegroundColor Cyan
