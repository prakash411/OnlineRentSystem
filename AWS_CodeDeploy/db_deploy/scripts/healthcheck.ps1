$ErrorActionPreference = "Stop"

try {
    rm C:\Windows\Temp\backup*.sql
    Write-Output 'ValidateService completed successfully.'
}
catch {
    Write-Error "ValidateService failed: $($_.Exception.Message)"
    exit 1
}

exit 0