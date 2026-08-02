<#
.SYNOPSIS
    This PowerShell script configures the Windows 11 minimum character PIN requirement to greater than 6 (six). 

.NOTES
    Author          : Raiques Crump  
    LinkedIn        : linkedin.com/in/raiqueslcrump/
    GitHub          : github.com/RLCrump40
    Date Created    : 2026-08-02
    Last Modified   : 2026-08-02
    Version         : 1R6
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000260
    Documentation   : https://stigaview.com/products/win11/v1r6/WN11-CC-000260/

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 


    Run as Administrator. If a MaximumPINLength value already exists and
    is lower than this MinimumPINLength, Windows will fall back to
    default values for both - this script does not touch MaximumPINLength,
    so verify compatibility if that value is already configured.
    A reboot (or at minimum a PIN reset by the user) is typically needed
    for the new minimum to be enforced on next PIN creation/change.

#>
 
#Requires -RunAsAdministrator
 
[CmdletBinding()]
param(
    [ValidateRange(4,127)]
    [int]$MinimumPinLength = 6
)
 
$ErrorActionPreference = 'Stop'
 
$RegPath   = 'HKLM:\SOFTWARE\Policies\Microsoft\PassportForWork\PINComplexity'
$ValueName = 'MinimumPINLength'
 
Write-Host "Remediating STIG WN11-CC-000260 (Minimum PIN length must be 6 or greater)..." -ForegroundColor Cyan
 
try {
    # Create the registry path if it doesn't exist
    if (-not (Test-Path $RegPath)) {
        Write-Host "Registry path not found. Creating: $RegPath"
        New-Item -Path $RegPath -Force | Out-Null
    }
 
    # Set (or create) the DWORD value
    New-ItemProperty -Path $RegPath -Name $ValueName -Value $MinimumPinLength -PropertyType DWord -Force | Out-Null
 
    Write-Host "Successfully set $ValueName = $MinimumPinLength at $RegPath" -ForegroundColor Green
}
catch {
    Write-Error "Failed to remediate WN11-CC-000260: $_"
    exit 1
}
 
# --- Verification ---
Write-Host "`nVerifying remediation..." -ForegroundColor Cyan
 
try {
    $current = Get-ItemProperty -Path $RegPath -Name $ValueName -ErrorAction Stop
    if ($current.$ValueName -ge 6) {
        Write-Host "PASS: $ValueName is set to $($current.$ValueName) (meets the 6-character minimum)." -ForegroundColor Green
    }
    else {
        Write-Warning "FAIL: $ValueName is set to $($current.$ValueName), which is below the required minimum of 6."
    }
}
catch {
    Write-Warning "FAIL: Could not read $ValueName from $RegPath. It may not have been set."
}
 
Write-Host "`nDone. Users will be prompted to set a new PIN meeting this length the next time they change or create one." -ForegroundColor Yellow
Write-Host "Run 'gpupdate /force' if you want Local Group Policy Editor to reflect this immediately." -ForegroundColor Yellow
 
