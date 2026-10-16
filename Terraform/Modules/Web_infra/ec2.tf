resource "aws_instance" "web-server-ec2" {
  ami                    = var.web-ec2-object.ami
  instance_type          = var.web-ec2-object.instance_type
  key_name               = var.web-ec2-object.aws_key
  subnet_id              = var.web-ec2-object.subnet_id
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  iam_instance_profile   = var.web-ec2-object.iam_profile
  tags = {
    Name = var.web-ec2-object.ec2_name
  }
  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  depends_on = [aws_security_group.web-sg]

  user_data = file("${path.module}/Scripts/user_data.ps1")

}




