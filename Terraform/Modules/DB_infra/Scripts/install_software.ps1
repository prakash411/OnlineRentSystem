<powershell>
$ErrorActionPreference = "Stop"
Write-Output "Executing user data script..."

param(
	[Parameter(Mandatory = $true)]
	[string]$Region
)

$ErrorActionPreference = "Stop"

Write-Output "Installing the CodeDeploy agent..."
$tempDirectory = "C:\tmp"
$installerPath = Join-Path $tempDirectory "codedeploy-agent.msi"
$installerLog = Join-Path $tempDirectory "codedeploy-agent-install.log"

New-Item -Path $tempDirectory -ItemType Directory -Force | Out-Null
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$service = Get-Service -Name "codedeployagent" -ErrorAction SilentlyContinue
if (-not $service) {
	Write-Output "Downloading the CodeDeploy agent MSI..."
	$installerUri = "https://s3.$Region.amazonaws.com/aws-codedeploy-$Region/latestv2/codedeploy-agent.msi"
    # $Url = "https://cdn.mysql.com/Downloads/MySQL-8.4/mysql-8.4.11-winx64.zip"
    # $Zip = "C:\Windows\Temp\mysql-8.4.11-winx64.zip"
    $WebClient = New-Object System.Net.WebClient
    $WebClient.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64)")
    $WebClient.DownloadFile($installerUri, $installerPath)
	# Invoke-WebRequest -Uri $installerUri -OutFile $installerPath -UseBasicParsing
	if (-not (Test-Path $installerPath) -or (Get-Item $installerPath).Length -eq 0) {
		throw "CodeDeploy agent MSI download is missing or empty."
	}

	Write-Output "Running the CodeDeploy agent installer..."
	$process = Start-Process -FilePath "msiexec.exe" `
		-ArgumentList "/i `"$installerPath`" /quiet /norestart /l*v `"$installerLog`"" `
		-Wait -PassThru
	if ($process.ExitCode -notin @(0, 3010)) {
        Write-Output "Installer log: $installerLog"
        cat $installerLog
		throw "CodeDeploy agent MSI failed with exit code $($process.ExitCode). Installer log: $installerLog"
	}

	$service = Get-Service -Name "codedeployagent" -ErrorAction SilentlyContinue
	if (-not $service) {
		$logTail = if (Test-Path $installerLog) { (Get-Content $installerLog -Tail 40) -join [Environment]::NewLine } else { "Installer log not found." }
		throw "MSI exited with code $($process.ExitCode), but the codedeployagent service was not registered. Installer log: $installerLog`n$logTail"
	}
}

if ($service.Status -ne "Running") {
	Start-Service -Name "codedeployagent"
	$service = Get-Service -Name "codedeployagent"
}

if ($service.Status -ne "Running") {
	throw "The CodeDeploy agent service exists but did not reach the Running state. Current state: $($service.Status)."
}

Write-Output "CodeDeploy agent is installed and running."


[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Write-Output "Downloading MySQL archive..."

$Url = "https://cdn.mysql.com/Downloads/MySQL-8.4/mysql-8.4.11-winx64.zip"
$Zip = "C:\Windows\Temp\mysql-8.4.11-winx64.zip"
$WebClient = New-Object System.Net.WebClient
$WebClient.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64)")
$WebClient.DownloadFile($Url, $Zip)

Write-Output "Extract and configure paths..."
Expand-Archive -Path $Zip -DestinationPath "C:\" -Force
Rename-Item -Path "C:\mysql-8.4.11-winx64" -NewName "C:\mysql" -Force
Remove-Item -Path $Zip -Force

Write-Output "Create MySQL data directory..."
New-Item -ItemType Directory -Path "C:\mysql\data" -Force | Out-Null


Write-Output "Generating C:\mysql\my.ini..."
@'
[mysqld]
basedir=C:/mysql
datadir=C:/mysql/data
port=3306
default_storage_engine=InnoDB
sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES

[client]
port=3306
'@ | Set-Content -Path "C:\mysql\my.ini" -Encoding ascii


Write-Output "Initializing MySQL data directory..."
C:\mysql\bin\mysqld.exe --initialize-insecure --basedir=C:\mysql --datadir=C:\mysql\data

Write-Output "Installing MySQL84 Windows service..."
C:\mysql\bin\mysqld.exe --install MySQL84 --defaults-file="C:\mysql\my.ini"

Write-Output "Starting MySQL84 service..."
Start-Service MySQL84

Write-Output "Add MySQL to System PATH...."
$mysqlBin = "C:\mysql\bin"
$machinePath = [Environment]::GetEnvironmentVariable("Path", "Machine")
if ($machinePath -notlike "*$mysqlBin*") {
    [Environment]::SetEnvironmentVariable("Path", "$machinePath;$mysqlBin", "Machine")
    $env:Path = "$env:Path;$mysqlBin"
}


Write-Output "Starting Amazon SSM Agent...."
Start-Service AmazonSSMAgent

Write-Output "User data script executed successfully."

</powershell>