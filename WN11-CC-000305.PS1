







 
#Requires -RunAsAdministrator
 
$RegPath      = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
$ValueName    = "AllowIndexingEncryptedStoresOrItems"
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
        Write-Host "WN11-CC-000305 remediated." -ForegroundColor Green
    } else {
        Write-Warning "Value did not apply as expected. Current value: $($current.$ValueName)"
    }
}
catch {
    Write-Error "Failed to remediate WN11-CC-000305: $_"
    exit 1
}
