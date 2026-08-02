













 
#Requires -RunAsAdministrator
 
[CmdletBinding()]
param()
 
$ErrorActionPreference = 'Stop'
 
$RegPath   = 'HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\Main'
$ValueName = 'NotifyDisableIEOptions'
$ExpectedValue = 0
 
Write-Host "Remediating STIG WN11-CC-000391 (Internet Explorer must be disabled for Windows 11)..." -ForegroundColor Cyan
 
try {
    # Create the registry path if it doesn't exist
    if (-not (Test-Path $RegPath)) {
        Write-Host "Registry path not found. Creating: $RegPath"
        New-Item -Path $RegPath -Force | Out-Null
    }
 
    # Set (or create) the DWORD value
    New-ItemProperty -Path $RegPath -Name $ValueName -Value $ExpectedValue -PropertyType DWord -Force | Out-Null
 
    Write-Host "Successfully set $ValueName = $ExpectedValue at $RegPath" -ForegroundColor Green
}
catch {
    Write-Error "Failed to remediate WN11-CC-000391: $_"
    exit 1
}
 
# --- Verification ---
Write-Host "`nVerifying remediation..." -ForegroundColor Cyan
 
try {
    $current = Get-ItemProperty -Path $RegPath -Name $ValueName -ErrorAction Stop
    if ($current.$ValueName -eq $ExpectedValue) {
        Write-Host "PASS: $ValueName is correctly set to $($current.$ValueName)." -ForegroundColor Green
    }
    else {
        Write-Warning "FAIL: $ValueName is set to $($current.$ValueName), expected $ExpectedValue."
    }
}
catch {
    Write-Warning "FAIL: Could not read $ValueName from $RegPath. It may not have been set."
}
 
Write-Host "`nDone. Run 'gpupdate /force' if you want Local Group Policy Editor to reflect this immediately." -ForegroundColor Yellow
