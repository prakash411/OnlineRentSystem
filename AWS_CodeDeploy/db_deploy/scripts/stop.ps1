$ErrorActionPreference = "Stop"

try {
    Write-Output 'ApplicationStop completed successfully.'
}
catch {
    Write-Error "ApplicationStop failed: $($_.Exception.Message)"
    exit 1
}

exit 0