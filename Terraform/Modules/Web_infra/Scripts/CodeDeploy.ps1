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
	Invoke-WebRequest -Uri $installerUri -OutFile $installerPath -UseBasicParsing
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



