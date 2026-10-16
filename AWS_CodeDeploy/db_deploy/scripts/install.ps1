$ErrorActionPreference = "Stop"



try {
    Write-Host "AfterInstall completed successfully"
}
catch {
    Write-Error "AfterInstall failed: $($_.Exception.Message)"
    exit 1
}

exit 0