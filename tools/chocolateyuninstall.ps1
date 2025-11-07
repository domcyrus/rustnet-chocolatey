$ErrorActionPreference = 'Stop'

$packageName = 'rustnet'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

# Remove the executable and related files
$exePath = Join-Path $toolsDir 'rustnet.exe'

if (Test-Path $exePath) {
  Remove-Item $exePath -Force -ErrorAction SilentlyContinue
}

# Clean up any additional files in the tools directory
Get-ChildItem $toolsDir -Exclude 'chocolatey*.ps1' | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue

Write-Host "RustNet has been uninstalled successfully!" -ForegroundColor Green
