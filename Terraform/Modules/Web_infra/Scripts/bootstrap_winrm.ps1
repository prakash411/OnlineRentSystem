<powershell>
write-output "Configuring WinRM for Packer..."

# Set administrator password or configure WinRM listener
netsh advfirewall firewall add rule name="WinRM-HTTP" dir=in localport=5985 protocol=TCP action=allow
netsh advfirewall firewall add rule name="WinRM-HTTPS" dir=in localport=5986 protocol=TCP action=allow

$Cert = New-SelfSignedCertificate -CertstoreLocation Cert:\LocalMachine\My -DnsName "packer"
New-Item -Path WSMan:\LocalHost\Listener -Transport HTTPS -Address * -CertificateThumbPrint $Cert.Thumbprint -Force

cmd.exe /c winrm quickconfig -q
cmd.exe /c winrm set winrm/config/service '@{AllowUnencrypted="false"}'
cmd.exe /c winrm set winrm/config/service/auth '@{Basic="true"}'

write-output "WinRM configuration complete."
</powershell>