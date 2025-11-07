# Helper script to update checksums when a new version is released
param(
    [Parameter(Mandatory=$true)]
    [string]$Version,

    [Parameter(Mandatory=$true)]
    [string]$Checksum
)

$ErrorActionPreference = 'Stop'

Write-Host "Updating RustNet Chocolatey package to version $Version" -ForegroundColor Cyan

# Update nuspec version
$nuspecPath = Join-Path $PSScriptRoot 'rustnet.nuspec'
$nuspecContent = Get-Content $nuspecPath -Raw
$nuspecContent = $nuspecContent -replace '<version>[\d\.]+</version>', "<version>$Version</version>"
Set-Content -Path $nuspecPath -Value $nuspecContent -NoNewline

# Update chocolateyinstall.ps1
$installScriptPath = Join-Path $PSScriptRoot 'tools\chocolateyinstall.ps1'
$installContent = Get-Content $installScriptPath -Raw
$installContent = $installContent -replace 'releases/download/v[\d\.]+/', "releases/download/v$Version/"
$installContent = $installContent -replace "checksum64 = '[^']*'", "checksum64 = '$Checksum'"
Set-Content -Path $installScriptPath -Value $installContent -NoNewline

# Update VERIFICATION.txt
$verificationPath = Join-Path $PSScriptRoot 'tools\VERIFICATION.txt'
$verificationContent = Get-Content $verificationPath -Raw
$verificationContent = $verificationContent -replace 'releases/download/v[\d\.]+/', "releases/download/v$Version/"
$verificationContent = $verificationContent -replace 'checksum64: [^\r\n]*', "checksum64: $Checksum"
Set-Content -Path $verificationPath -Value $verificationContent -NoNewline

Write-Host "Updated to version $Version with checksum $Checksum" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Review the changes: git diff" -ForegroundColor White
Write-Host "2. Test the package: choco pack && choco install rustnet -source . -y" -ForegroundColor White
Write-Host "3. Commit and push: git add . && git commit -m 'Update to version $Version' && git push" -ForegroundColor White
