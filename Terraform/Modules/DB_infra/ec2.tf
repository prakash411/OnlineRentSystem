resource "aws_instance" "db-server-ec2" {
  ami                    = var.db-ec2-object.ami
  instance_type          = var.db-ec2-object.instance_type
  key_name               = var.db-ec2-object.aws_key
  subnet_id              = var.db-ec2-object.subnet_id
  vpc_security_group_ids = [aws_security_group.db-sg.id]
  iam_instance_profile   = var.db-ec2-object.iam_profile
  tags = {
    Name = var.db-ec2-object.ec2_name
  }
  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  depends_on = [aws_security_group.db-sg]

  user_data = file("${path.module}/Scripts/user_data.ps1")

}




