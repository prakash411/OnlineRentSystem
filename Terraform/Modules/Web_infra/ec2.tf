resource "aws_instance" "web-server-ec2" {
  ami                    = var.web-ec2-object.ami
  instance_type          = var.web-ec2-object.instance_type
  key_name               = var.web-ec2-object.aws_key
  subnet_id              = var.web-ec2-object.subnet_id
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  iam_instance_profile   = var.web-ec2-object.iam_profile
  get_password_data      = true
  tags = {
    Name = var.web-ec2-object.ec2_name
  }
  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  depends_on = [aws_security_group.web-sg]

  user_data = file("${path.module}/Scripts/bootstrap_winrm.ps1")

  connection {
    type     = "winrm"
    host     = self.public_ip
    user     = "Administrator"
    password = rsadecrypt(self.password_data, var.web-ec2-object.private_key)
    https    = true
    insecure = true
    timeout  = "15m"
  }

  provisioner "file" {
    source      = "${path.module}/Scripts/CodeDeploy.ps1"
    destination = "C:/Windows/Temp/CodeDeploy.ps1"
  }

  provisioner "file" {
    source      = "${path.module}/Scripts/iis.ps1"
    destination = "C:/Windows/Temp/iis.ps1"
  }

  provisioner "remote-exec" {
    inline = [
      "powershell.exe -NoLogo -NoProfile -NonInteractive -ExecutionPolicy Bypass -File C:/Windows/Temp/CodeDeploy.ps1 -Region ${var.web-ec2-object.aws_region}",
      "powershell.exe -NoLogo -NoProfile -NonInteractive -ExecutionPolicy Bypass -File C:/Windows/Temp/iis.ps1"
    ]
  }

}




