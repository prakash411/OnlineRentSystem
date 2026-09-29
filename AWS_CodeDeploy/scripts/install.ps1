<powershell>
Write-Output 'Installing IIS'
Install-WindowsFeature -Name Web-Server -IncludeManagementTools
</powershell>