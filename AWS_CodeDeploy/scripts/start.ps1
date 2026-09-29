<powershell>
Write-Output 'Starting IIS'
Start-Service W3SVC
Set-Service W3SVC -StartupType Automatic

New-NetFirewallRule `
    -DisplayName "Allow HTTP 80" `
    -Direction Inbound `
    -Protocol TCP `
    -LocalPort 80 `
    -Action Allow
</powershell>