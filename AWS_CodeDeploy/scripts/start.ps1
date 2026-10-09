# Relaunch in 64-bit PowerShell if running in 32-bit (SysWOW64)
if ([IntPtr]::Size -eq 4 -and (Test-Path "$env:WINDIR\SysNative\WindowsPowerShell\v1.0\powershell.exe")) {
    & "$env:WINDIR\SysNative\WindowsPowerShell\v1.0\powershell.exe" -ExecutionPolicy Bypass -File $MyInvocation.MyCommand.Path
    exit $LASTEXITCODE
}

$ErrorActionPreference = "Stop"

# The IIS WebAdministration provider requires the 64-bit IIS management COM components.

try {
    Write-Output "Starting IIS configuration in 64-bit PowerShell."
    Import-Module WebAdministration -ErrorAction Stop

    New-WebAppPool -Name "MyWebsitePool";
    Set-ItemProperty "IIS:\AppPools\MyWebsitePool" -Name managedRuntimeVersion -Value "v4.0";
    New-Website -Name "MyWebsite" -PhysicalPath "C:\MyApp" -ApplicationPool "MyWebsitePool" -Port 8080 -IPAddress "*"
}
catch {
    Write-Error "ApplicationStart failed: $($_.Exception.Message)"
    exit 1
}

exit 0