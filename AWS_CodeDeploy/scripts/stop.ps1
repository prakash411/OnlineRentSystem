$ErrorActionPreference = "Stop"

try {
    Import-Module WebAdministration -ErrorAction Stop
    remove-Website -Name "MyWebsite"
    remove-WebAppPool -Name "MyWebsitePool"
    Write-Output 'ApplicationStop completed successfully.'
}
catch {
    Write-Error "ApplicationStop failed: $($_.Exception.Message)"
    exit 1
}

exit 0