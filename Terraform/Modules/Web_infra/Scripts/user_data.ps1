<powershell>
Write-Output "Executing user data script..."
mkdir C:\tmp
Write-Output "tmp directory created successfully."
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Write-Output "Downloading MSI for CodeDeploy agent..."
Invoke-WebRequest https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/codedeploy-agent.msi -OutFile C:\tmp\agent.msi
Write-Output "MSI downloaded successfully."
Start-Process msiexec.exe -ArgumentList "/i C:\tmp\agent.msi " -Wait
Write-Output "CodeDeploy agent installed successfully."
Start-Service codedeployagent
</powershell>

