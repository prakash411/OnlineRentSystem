resource "aws_instance" "db-server-ec2" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.aws_key
  vpc_security_group_ids = [aws_security_group.db-sg.id]
  iam_instance_profile   = var.iam_profile
  tags = {
    "Name" = var.ec2_name
  }
  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }
  get_password_data = true
  
  depends_on = [ aws_security_group.db-sg ]

  user_data = file("${path.module}/Scripts/user_data.ps1")  
  
}




