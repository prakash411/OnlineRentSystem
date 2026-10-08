$ErrorActionPreference = "Stop"

Write-Host "Installing IIS"

try {
    Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerRole, IIS-WebServer, IIS-CommonHttpFeatures, IIS-ManagementConsole -All

    Write-Output 'Starting IIS'
    Start-Service W3SVC
    Set-Service W3SVC -StartupType Automatic

    New-NetFirewallRule -DisplayName "Allow HTTP 8080" -Direction Inbound `
        -Protocol TCP -LocalPort 8080 -Action Allow

    Write-Host "IIS installation completed successfully"
}
catch {
    Write-Error "IIS installation failed: $($_.Exception.Message)"
    exit 1
}

exit 0