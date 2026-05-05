$ErrorActionPreference = 'Stop'

$packageName = 'rustnet'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64 = 'https://github.com/domcyrus/rustnet/releases/download/v1.3.0/rustnet-v1.3.0-x86_64-pc-windows-msvc.zip'
$checksum64 = '47bd489ea39f0e1238e871b9d4190b7928f1566c34fd51cb91b64cf9d2b4a4f9'
$checksumType64 = 'sha256'

# Check if Npcap is installed by looking for wpcap.dll
$npcapInstalled = $false
$systemRoot = $env:SystemRoot
$wpcapPath = Join-Path $systemRoot 'System32\Npcap\wpcap.dll'
$wpcapLegacyPath = Join-Path $systemRoot 'System32\wpcap.dll'

if ((Test-Path $wpcapPath) -or (Test-Path $wpcapLegacyPath)) {
    $npcapInstalled = $true
}

if (-not $npcapInstalled) {
    Write-Host ""
    Write-Host "WARNING: Npcap is not detected on this system." -ForegroundColor Yellow
    Write-Host "RustNet requires Npcap for packet capture." -ForegroundColor Yellow
    Write-Host "Download from: https://npcap.com/dist/" -ForegroundColor Cyan
    Write-Host "IMPORTANT: Select 'WinPcap API-compatible Mode' during installation." -ForegroundColor Cyan
    Write-Host ""
}

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
Write-Host ""
Write-Host "GEOIP (OPTIONAL):" -ForegroundColor Yellow
Write-Host "To show country codes and city names for remote IPs, install GeoLite2 databases:" -ForegroundColor Cyan
Write-Host "  1. Download geoipupdate from https://github.com/maxmind/geoipupdate/releases" -ForegroundColor Cyan
Write-Host "  2. Sign up for a free MaxMind account at https://www.maxmind.com" -ForegroundColor Cyan
Write-Host "  3. Edit %LOCALAPPDATA%\GeoIP\GeoIP.conf and set:" -ForegroundColor Cyan
Write-Host "       EditionIDs GeoLite2-City GeoLite2-ASN" -ForegroundColor Cyan
Write-Host "  4. Run: geoipupdate" -ForegroundColor Cyan
Write-Host "  Tip: GeoLite2-City includes country data - no need for GeoLite2-Country." -ForegroundColor Cyan
Write-Host "See: https://github.com/domcyrus/rustnet/blob/main/INSTALL.md#geoip-databases-optional" -ForegroundColor Cyan
