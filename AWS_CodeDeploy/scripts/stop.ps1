$ErrorActionPreference = "Stop"

if (-not (Get-Module -ListAvailable -Name WebAdministration)) {
    Write-Output "IIS management tools are not installed; skipping ApplicationStop cleanup."
    exit 0
}

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
    $errorRecord = $_
    $errorText = @($errorRecord.ToString(), $errorRecord.Exception.ToString()) -join "`n"
    $comRegistrationError = $false
    $exception = $_.Exception
    while ($exception) {
        $errorText += "`n$($exception.Message)"
        if ($exception.HResult -eq -2147221164) {
            $comRegistrationError = $true
            break
        }
        $exception = $exception.InnerException
    }

    if (-not $comRegistrationError) {
        $comRegistrationError = $errorText -match '(?i)80040154|688EEEE5-6A7E-422F-B2E1-6AF00DC944A6'
    }

    if ($comRegistrationError) {
        Write-Warning "IIS management COM components are not registered; skipping ApplicationStop cleanup."
        exit 0
    }

    [Console]::Error.WriteLine("ApplicationStop failed: $($_.Exception.Message)")
    exit 1
}

exit 0