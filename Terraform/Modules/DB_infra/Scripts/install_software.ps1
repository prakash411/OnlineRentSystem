<powershell>
$ErrorActionPreference = "Stop"
Write-Output "Executing user data script..."

$Url = "https://awscli.amazonaws.com/AWSCLIV2-2.37.13.msi"
$Installer = "C:\Windows\Temp\AWSCLIV2-2.37.13.msi"
write-Output "Downloading AWS CLI..."
Invoke-WebRequest -Uri $Url -OutFile $Installer

write-Output "Installing AWS CLI..."
Start-Process -FilePath "msiexec.exe" -ArgumentList "/i C:\Windows\Temp\AWSCLIV2-2.37.13.msi /quiet" -Wait

write-output "setting env path for AWS CLI..."
$awsExe = "C:\Program Files\Amazon\AWSCLIV2\aws.exe"
$awsPath = "C:\Program Files\Amazon\AWSCLIV2"
$machinePath = [Environment]::GetEnvironmentVariable("Path", "Machine")
if ($machinePath -notlike "*$awsPath*") {
    [Environment]::SetEnvironmentVariable("Path", "$machinePath;$awsPath", "Machine")
    $env:Path = "$env:Path;$awsPath"
}




[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$Url = "https://cdn.mysql.com/Downloads/MySQL-8.4/mysql-8.4.11-winx64.zip"
$Installer = "C:\Windows\Temp\mysql-8.4.11-winx64.zip"
write-Output "Downloading mysql..."
Invoke-WebRequest -Uri $Url -OutFile $Installer

Write-Output "Extract and configure paths..."
$Zip = "C:\Windows\Temp\mysql-8.4.11-winx64.zip"
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


Write-Output "Executing SQL commands...."
New-NetFirewallRule -DisplayName "MySQL Port 3306" -Direction Inbound -LocalPort 3306 -Protocol TCP -Action Allow -Profile Any
Get-Content -Path "C:\Windows\Temp\backup.sql" | Set-Content -Path "C:\Windows\Temp\backup_utf8.sql" -Encoding utf8

& "C:\mysql\bin\mysql.exe" -u root -e "SOURCE C:/Windows/Temp/backup_utf8.sql;"
& "C:\mysql\bin\mysql.exe" -u root -e "CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY 'root';"
& "C:\mysql\bin\mysql.exe" -u root -e "ALTER USER 'root'@'%' IDENTIFIED BY 'root';"
& "C:\mysql\bin\mysql.exe" -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;"
& "C:\mysql\bin\mysql.exe" -u root -e "FLUSH PRIVILEGES;"
& "C:\mysql\bin\mysql.exe" -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'root';"

Write-Output "Starting Amazon SSM Agent...."
Start-Service AmazonSSMAgent

Write-Output "User data script executed successfully."

</powershell>