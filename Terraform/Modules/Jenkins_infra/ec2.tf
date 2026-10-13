resource "aws_instance" "Jenkins-ec2" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.aws_key
  vpc_security_group_ids = [aws_security_group.jenkins-sg.id]
  iam_instance_profile   = var.iam_profile
  tags = {
    "Name" = var.ec2_name
  }
  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }
  
  depends_on = [ aws_security_group.jenkins-sg ]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = var.private_key
    host        = self.public_ip
  }

  provisioner "remote-exec"{
    scripts = [
      "${path.module}/Scripts/jenkins-install.sh"
    ]
  }
  
}




