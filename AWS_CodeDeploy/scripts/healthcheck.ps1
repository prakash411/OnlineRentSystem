$ErrorActionPreference = "Stop"

if (-not [Environment]::Is64BitProcess) {
    $nativePowerShell = Join-Path $env:WINDIR 'Sysnative\WindowsPowerShell\v1.0\powershell.exe'
    if (-not (Test-Path $nativePowerShell)) {
        throw 'IIS deployment must run in 64-bit Windows PowerShell, but the 64-bit host was not found.'
    }

    & $nativePowerShell -NoProfile -ExecutionPolicy Bypass -File $PSCommandPath
    exit $LASTEXITCODE
}

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