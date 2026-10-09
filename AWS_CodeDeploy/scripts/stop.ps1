# Relaunch in 64-bit PowerShell if running in 32-bit (SysWOW64)
if ([IntPtr]::Size -eq 4 -and (Test-Path "$env:WINDIR\SysNative\WindowsPowerShell\v1.0\powershell.exe")) {
    & "$env:WINDIR\SysNative\WindowsPowerShell\v1.0\powershell.exe" -ExecutionPolicy Bypass -File $MyInvocation.MyCommand.Path
    exit $LASTEXITCODE
}

$ErrorActionPreference = "Stop"

# Verify Web-Scripting-Tools is actually installed before calling WebAdministration
$iisFeature = Get-WindowsFeature -Name Web-Scripting-Tools -ErrorAction SilentlyContinue
if (-not ($iisFeature -and $iisFeature.Installed)) {
    Write-Output "IIS Scripting Tools not installed; skipping ApplicationStop cleanup."
    exit 0
}

try {
    Write-Output "Importing WebAdministration..."
    Import-Module WebAdministration -ErrorAction Stop

    $siteName = "MyWebsite"
    $poolName = "MyWebsitePool"

    if (Get-Website -Name $siteName -ErrorAction SilentlyContinue) {
        Remove-Website -Name $siteName
        Write-Output "Website '$siteName' removed."
    }
    else {
        Write-Output "Website '$siteName' does not exist. Skipping."
    }

    if (Get-WebAppPool -Name $poolName -ErrorAction SilentlyContinue) {
        Remove-WebAppPool -Name $poolName
        Write-Output "App Pool '$poolName' removed."
    }
    else {
        Write-Output "App Pool '$poolName' does not exist. Skipping."
    }

    Write-Output "ApplicationStop completed successfully."
}
catch {
    Write-Error "ApplicationStop failed: $($_.Exception.Message)"
    exit 1
}

exit 0