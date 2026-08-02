










#Requires -RunAsAdministrator
 
[CmdletBinding()]
param(
    [string]$NewGuestName = 'DisabledGuestAcct'
)
 
$ErrorActionPreference = 'Stop'
 
Write-Host "Remediating STIG WN11-SO-000025 (Built-in guest account must be renamed)..." -ForegroundColor Cyan
 
# Find the built-in Guest account by well-known RID (-501), not by name,
# in case it has already been renamed to something non-default.
try {
    $guest = Get-CimInstance -ClassName Win32_UserAccount -Filter "LocalAccount=True" |
        Where-Object { $_.SID -like '*-501' }
}
catch {
    Write-Error "Failed to query local accounts: $_"
    exit 1
}
 
if (-not $guest) {
    Write-Error "Could not locate the built-in Guest account (SID ending in -501) on this system."
    exit 1
}
 
Write-Host "Found built-in guest account: '$($guest.Name)' (SID: $($guest.SID))"
 
if ($guest.Name -eq $NewGuestName) {
    Write-Host "Account is already named '$NewGuestName'. No change needed." -ForegroundColor Green
}
else {
    try {
        # Preferred method: Rename-LocalUser (Microsoft.PowerShell.LocalAccounts module)
        if (Get-Command Rename-LocalUser -ErrorAction SilentlyContinue) {
            Rename-LocalUser -Name $guest.Name -NewName $NewGuestName
        }
        else {
            # Fallback: WMI rename
            $wmiAccount = Get-WmiObject -Class Win32_UserAccount -Filter "SID='$($guest.SID)'"
            $result = $wmiAccount.Rename($NewGuestName)
            if ($result.ReturnValue -ne 0) {
                throw "WMI Rename() returned error code $($result.ReturnValue)"
            }
        }
        Write-Host "Successfully renamed guest account to '$NewGuestName'." -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to rename guest account: $_"
        exit 1
    }
}
 
# --- Verification ---
Write-Host "`nVerifying remediation..." -ForegroundColor Cyan
 
try {
    $verify = Get-CimInstance -ClassName Win32_UserAccount -Filter "LocalAccount=True" |
        Where-Object { $_.SID -like '*-501' }
 
    if ($verify.Name -eq $NewGuestName -and $verify.Name -ne 'Guest') {
        Write-Host "PASS: Built-in guest account is now named '$($verify.Name)'." -ForegroundColor Green
    }
    else {
        Write-Warning "FAIL: Built-in guest account name is '$($verify.Name)', expected '$NewGuestName'."
    }
}
catch {
    Write-Warning "FAIL: Could not verify the guest account rename: $_"
}
 
Write-Host "`nDone." -ForegroundColor Yellow
 
