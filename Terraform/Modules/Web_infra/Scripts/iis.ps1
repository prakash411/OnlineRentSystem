$ErrorActionPreference = "Stop"

Write-Host "Installing IIS"

try {
    Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerRole, IIS-WebServer, IIS-CommonHttpFeatures,`
     IIS-ManagementConsole, IIS-ManagementScriptingTools -All

    Write-Output 'Starting IIS'
    Start-Service W3SVC
    Set-Service W3SVC -StartupType Automatic

    New-NetFirewallRule -DisplayName "Allow HTTP 8080" -Direction Inbound `
        -Protocol TCP -LocalPort 8080 -Action Allow

    Write-Host "IIS installation completed successfully"
}
catch {
    throw "IIS installation failed: $($_.Exception.Message)"
}

Write-Output "Starting dotnet-hosting installation..."
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$Url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.12/dotnet-hosting-10.0.12-win.exe"
$Installer = "$env:TEMP\dotnet-hosting-10.0.12-win.exe"
$WebClient = New-Object System.Net.WebClient
$WebClient.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64)")
$WebClient.DownloadFile($Url, $Installer)
# Invoke-WebRequest -Uri $Url -OutFile $Installer
$process = Start-Process -FilePath $Installer -ArgumentList "/install /quiet /norestart" -Wait -PassThru
if ($process.ExitCode -notin @(0, 3010)) {
    throw "dotnet-hosting failed with exit code $($process.ExitCode)."
}