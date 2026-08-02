<#
.SYNOPSIS
    This PowerShell script disables Internet Connection Sharing in Windows 11.

.NOTES
    Author          : Raiques Crump  
    LinkedIn        : linkedin.com/in/raiqueslcrump/
    GitHub          : github.com/RLCrump40
    Date Created    : 2026-08-02
    Last Modified   : 2026-08-02
    Version         : 2R3
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000044
    Documentation   : https://stigaview.com/products/win11/v2r3/WN11-CC-000044/

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE

#>
 
#Requires -RunAsAdministrator
 
$RegPath  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Network Connections"
$ValueName = "NC_ShowSharedAccessUI"
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
        Write-Host "WN11-CC-000044 remediated." -ForegroundColor Green
    } else {
        Write-Warning "Value did not apply as expected. Current value: $($current.$ValueName)"
    }
}
catch {
    Write-Error "Failed to remediate WN11-CC-000044: $_"
    exit 1
}
 
