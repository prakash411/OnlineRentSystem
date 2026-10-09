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