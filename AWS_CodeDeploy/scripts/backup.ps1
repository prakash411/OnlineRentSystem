$ErrorActionPreference = "Stop"

try {
    Write-Output 'BeforeInstall completed successfully.'
}
catch {
    Write-Error "BeforeInstall failed: $($_.Exception.Message)"
    exit 1
}

exit 0