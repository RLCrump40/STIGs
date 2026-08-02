<#
.SYNOPSIS
    This PowerShell script configures the "Minimum password length" security policy to 14 characters.

.NOTES
    Author          : Raiques Crump  
    LinkedIn        : linkedin.com/in/raiqueslcrump/
    GitHub          : github.com/RLCrump40
    Date Created    : 2026-08-02
    Last Modified   : 2026-08-02
    Version         : 1R5
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000035
    Documentation   : https://stigaview.com/products/win11/v1r5/WN11-AC-000035/

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE

#Requires -RunAsAdministrator
 
$DesiredMinLength = 14
 
try {
    Write-Host "Configuring minimum password length to $DesiredMinLength characters..." -ForegroundColor Yellow
 
    $result = & net accounts /minpwlen:$DesiredMinLength 2>&1
 
    if ($LASTEXITCODE -ne 0) {
        throw "net accounts command failed: $result"
    }
 
    # Verify
    $currentSettings = net accounts
    $minLenLine = $currentSettings | Select-String "Minimum password length"
 
    Write-Host "SUCCESS: Minimum password length configured." -ForegroundColor Green
    Write-Host $minLenLine -ForegroundColor Green
    Write-Host "WN11-AC-000035 remediated." -ForegroundColor Green
    Write-Host "`nNote: If this system is domain-joined, verify Group Policy does not override this with a less restrictive value on next refresh." -ForegroundColor Cyan
}
catch {
    Write-Error "Failed to remediate WN11-AC-000035: $_"
    exit 1
}
 
