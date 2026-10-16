$ErrorActionPreference = "Stop"

try {
    
    Write-Output "Executing SQL commands...."
    New-NetFirewallRule -DisplayName "MySQL Port 3306" -Direction Inbound -LocalPort 3306 -Protocol TCP -Action Allow -Profile Any
    Get-Content -Path "C:\Windows\Temp\backup.sql" | Set-Content -Path "C:\Windows\Temp\backup_utf8.sql" -Encoding utf8

    & "C:\mysql\bin\mysql.exe" -u root -e "SOURCE C:/Windows/Temp/backup_utf8.sql;"
    & "C:\mysql\bin\mysql.exe" -u root -e "CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY 'root';"
    & "C:\mysql\bin\mysql.exe" -u root -e "ALTER USER 'root'@'%' IDENTIFIED BY 'root';"
    & "C:\mysql\bin\mysql.exe" -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;"
    & "C:\mysql\bin\mysql.exe" -u root -e "FLUSH PRIVILEGES;"
    & "C:\mysql\bin\mysql.exe" -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'root';"
    Write-Output 'ApplicationStart completed successfully.'
}
catch {
    Write-Error "ApplicationStart failed: $($_.Exception.Message)"
    exit 1
}

exit 0