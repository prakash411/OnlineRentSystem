resource "aws_instance" "sonarqube-ec2" {
  ami                    = var.sonarqube-ec2-object.ami
  instance_type          = var.sonarqube-ec2-object.instance_type
  key_name               = var.sonarqube-ec2-object.aws_key
  subnet_id              = var.sonarqube-ec2-object.subnet_id
  vpc_security_group_ids = [aws_security_group.sonarqube-sg.id]
  iam_instance_profile   = var.sonarqube-ec2-object.iam_profile
  tags = {
    "Name" = var.sonarqube-ec2-object.ec2_name
  }
  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  depends_on = [aws_security_group.sonarqube-sg]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = var.sonarqube-ec2-object.private_key
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    scripts = [
      "${path.module}/Scripts/sonarqube-install.sh"
    ]
  }
}




