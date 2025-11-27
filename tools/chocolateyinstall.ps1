$ErrorActionPreference = 'Stop'

$packageName = 'rustnet'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64 = 'https://github.com/domcyrus/rustnet/releases/download/v0.16.1/rustnet-v0.16.1-x86_64-pc-windows-msvc.zip'
$checksum64 = '5d78bf6bffa8badfce29092143734c5354f267bed3a62acae4c3febe662c9ce2'
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

# Find the executable (it's inside a versioned folder)
$extractedExe = Get-ChildItem -Path $toolsDir -Filter 'rustnet.exe' -Recurse | Select-Object -First 1

# Verify the executable exists
if (-not $extractedExe) {
  throw "RustNet executable not found in $toolsDir"
}

# Move executable and assets to tools directory root
$extractedDir = $extractedExe.Directory.FullName
Move-Item -Path (Join-Path $extractedDir 'rustnet.exe') -Destination $toolsDir -Force
if (Test-Path (Join-Path $extractedDir 'assets')) {
  Move-Item -Path (Join-Path $extractedDir 'assets') -Destination $toolsDir -Force
}

# Clean up extracted folder
Remove-Item -Path $extractedDir -Recurse -Force -ErrorAction SilentlyContinue

$exePath = Join-Path $toolsDir 'rustnet.exe'

Write-Host "RustNet has been installed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "IMPORTANT: Npcap Runtime is required for packet capture." -ForegroundColor Yellow
Write-Host "Download the Npcap installer (e.g., npcap-1.84.exe) from https://npcap.com/dist/" -ForegroundColor Cyan
Write-Host "During installation, select 'WinPcap API compatible mode'" -ForegroundColor Cyan
Write-Host ""
Write-Host "After installing Npcap, run 'rustnet' from the command line." -ForegroundColor Green
