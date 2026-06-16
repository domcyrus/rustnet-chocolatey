$ErrorActionPreference = 'Stop'

$packageName = 'rustnet'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64 = 'https://github.com/domcyrus/rustnet/releases/download/v1.4.0/rustnet-v1.4.0-x86_64-pc-windows-msvc.zip'
$checksum64 = '84bc9226ed0b82ac143ca549375b117256f3abcb151d519e8885a8a214c7f579'
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

# On upgrade, Chocolatey restores the previous install's files into
# $toolsDir before running this script. Those leftovers (a stale
# rustnet.exe at the root and an assets\ folder) would poison the
# recursive search below and cause the cleanup step to wipe $toolsDir.
# Strip everything except the install/uninstall scripts before extracting.
Get-ChildItem -Path $toolsDir -Force -Exclude 'chocolatey*.ps1' | Remove-Item -Recurse -Force

$packageArgs = @{
  packageName    = $packageName
  unzipLocation  = $toolsDir
  url64bit       = $url64
  checksum64     = $checksum64
  checksumType64 = $checksumType64
}

Install-ChocolateyZipPackage @packageArgs

# The archive always extracts a single versioned subfolder. Match it
# directly instead of recursively hunting for rustnet.exe — a recursive
# search can match a leftover file at the tools root and turn the
# cleanup below into a recursive delete of $toolsDir itself.
$extractedDir = Get-ChildItem -Path $toolsDir -Directory -Filter 'rustnet-v*-pc-windows-msvc' | Select-Object -First 1
if (-not $extractedDir) {
  throw "Expected versioned subfolder (rustnet-v*-pc-windows-msvc) not found in $toolsDir after extraction"
}
if ($extractedDir.FullName -eq $toolsDir) {
  throw "Refusing to operate: extracted directory resolved to `$toolsDir itself"
}
$exeSource = Join-Path $extractedDir.FullName 'rustnet.exe'
if (-not (Test-Path $exeSource)) {
  throw "rustnet.exe not found in extracted archive at $exeSource"
}

Move-Item -Path $exeSource -Destination $toolsDir -Force
if (Test-Path (Join-Path $extractedDir.FullName 'assets')) {
  Move-Item -Path (Join-Path $extractedDir.FullName 'assets') -Destination $toolsDir -Force
}

Remove-Item -Path $extractedDir.FullName -Recurse -Force

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
