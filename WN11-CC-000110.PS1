
<#
.SYNOPSIS
    This PowerShell script sets the "Turn off printing over HTTP" Group Policy setting to Enabled by
    configuring the underlying registry value.

.NOTES
    Author          : Raiques Crump  
    LinkedIn        : linkedin.com/in/raiqueslcrump/
    GitHub          : github.com/RLCrump40
    Date Created    : 2026-08-02
    Last Modified   : 2026-08-02
    Version         : 1R5
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000110
    Documentation   : https://stigaview.com/products/win11/v2r2/WN11-CC-000110/

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE


$RegPath  = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers'
$ValueName = 'DisableHTTPPrinting'
$ExpectedValue = 1


#Requires -RunAsAdministrator

[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

$RegPath  = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers'
$ValueName = 'DisableHTTPPrinting'
$ExpectedValue = 1

Write-Host "Remediating STIG WN11-CC-000110 (Printing over HTTP must be prevented)..." -ForegroundColor Cyan

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
    Write-Error "Failed to remediate WN11-CC-000110: $_"
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
