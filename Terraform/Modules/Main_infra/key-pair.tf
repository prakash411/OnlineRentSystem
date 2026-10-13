resource "tls_private_key" "my_key" {
  algorithm = "RSA"
}

resource "local_file" "my_private_key" {
  filename = "${path.root}/keys/my_private_key.pem"
  content  = tls_private_key.my_key.private_key_pem

  depends_on = [ tls_private_key.my_key ]

  lifecycle {
    replace_triggered_by = [ tls_private_key.my_key ]
    
  }
}

resource "aws_key_pair" "ec2-key" {
  key_name   = "my-ec2-key"
  public_key = tls_private_key.my_key.public_key_openssh
}

