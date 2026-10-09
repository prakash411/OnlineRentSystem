# Relaunch in 64-bit PowerShell if running in 32-bit (SysWOW64)
if ([IntPtr]::Size -eq 4 -and (Test-Path "$env:WINDIR\SysNative\WindowsPowerShell\v1.0\powershell.exe")) {
    & "$env:WINDIR\SysNative\WindowsPowerShell\v1.0\powershell.exe" -ExecutionPolicy Bypass -File $MyInvocation.MyCommand.Path
    exit $LASTEXITCODE
}

$ErrorActionPreference = "Stop"

try {
    Write-Output "Starting IIS configuration in 64-bit PowerShell."
    Import-Module WebAdministration -ErrorAction Stop
    Write-Output 'ValidateService completed successfully.'
    get-Service W3SVC
    get-website
    get-webbinding
}
catch {
    Write-Error "ValidateService failed: $($_.Exception.Message)"
    exit 1
}

exit 0