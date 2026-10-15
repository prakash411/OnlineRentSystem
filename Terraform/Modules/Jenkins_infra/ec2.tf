resource "aws_instance" "Jenkins-ec2" {
  ami                    = var.jenkins-ec2-object.ami
  instance_type          = var.jenkins-ec2-object.instance_type
  key_name               = var.jenkins-ec2-object.aws_key
  subnet_id              = var.jenkins-ec2-object.subnet_id
  vpc_security_group_ids = [aws_security_group.jenkins-sg.id]
  iam_instance_profile   = var.jenkins-ec2-object.iam_profile
  tags = {
    Name = var.jenkins-ec2-object.ec2_name
  }
  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  depends_on = [aws_security_group.jenkins-sg]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = var.jenkins-ec2-object.private_key
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    scripts = [
      "${path.module}/Scripts/jenkins-install.sh"
    ]
  }

}




