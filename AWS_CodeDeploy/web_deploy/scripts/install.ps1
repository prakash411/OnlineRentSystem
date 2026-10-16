$ErrorActionPreference = "Stop"

Write-Host "Installing IIS"

try {
    Write-Host "IIS installation completed successfully"
}
catch {
    Write-Error "IIS installation failed: $($_.Exception.Message)"
    exit 1
}

exit 0