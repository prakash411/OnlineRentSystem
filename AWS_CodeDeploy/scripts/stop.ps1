$ErrorActionPreference = "Stop"

try {
    Import-Module WebAdministration -ErrorAction Stop

    $siteName = "MyWebsite"
    $poolName = "MyWebsitePool"

    # Remove Website only if it exists
    if (Get-Website -Name $siteName -ErrorAction SilentlyContinue) {
        Remove-Website -Name $siteName
        Write-Output "Website '$siteName' removed."
    }
    else {
        Write-Output "Website '$siteName' does not exist. Skipping."
    }

    # Remove App Pool only if it exists
    if (Get-WebAppPool -Name $poolName -ErrorAction SilentlyContinue) {
        Remove-WebAppPool -Name $poolName
        Write-Output "App Pool '$poolName' removed."
    }
    else {
        Write-Output "App Pool '$poolName' does not exist. Skipping."
    }

    Write-Output 'ApplicationStop completed successfully.'
}
catch {
    Write-Error "ApplicationStop failed: $($_.Exception.Message)"
    exit 1
}

exit 0