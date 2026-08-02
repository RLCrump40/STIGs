<#
.SYNOPSIS
    This PowerShell script configures the registry to disable user control over Windows Installer installs.

.NOTES
    Author          : Raiques Crump  
    LinkedIn        : linkedin.com/in/raiqueslcrump/
    GitHub          : github.com/RLCrump40
    Date Created    : 2026-08-02
    Last Modified   : 2026-08-02
    Version         : 2R3
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000310
    Documentation   : https://stigaview.com/products/win11/v2r1/WN11-CC-000310/

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE

>
 
#Requires -RunAsAdministrator
 
$RegPath      = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Installer"
$ValueName    = "EnableUserControl"
$DesiredValue = 0
 
try {
    # Create the registry path if it doesn't already exist
    if (-not (Test-Path $RegPath)) {
        New-Item -Path $RegPath -Force | Out-Null
        Write-Host "Created registry path: $RegPath"
    }
 
    # Set (or create) the DWORD value
    New-ItemProperty -Path $RegPath -Name $ValueName -Value $DesiredValue -PropertyType DWord -Force | Out-Null
 
    # Verify
    $current = Get-ItemProperty -Path $RegPath -Name $ValueName -ErrorAction Stop
    if ($current.$ValueName -eq $DesiredValue) {
        Write-Host "SUCCESS: $ValueName set to $DesiredValue at $RegPath" -ForegroundColor Green
        Write-Host "WN11-CC-000310 remediated." -ForegroundColor Green
    } else {
        Write-Warning "Value did not apply as expected. Current value: $($current.$ValueName)"
    }
}
catch {
    Write-Error "Failed to remediate WN11-CC-000310: $_"
    exit 1
}
 

