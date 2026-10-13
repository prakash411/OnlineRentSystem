resource "aws_security_group" "web-sg" {
  name        = "web-sg"
  description = "this sg allow for web servers"
  vpc_id = var.vpc_id
  egress {
    protocol    = "ALL"
    from_port   = "0"
    to_port     = "0"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc_security_group_ingress_rule" "winrm-http" {
  security_group_id = aws_security_group.web-sg.id
  ip_protocol       = "tcp"
  from_port         = 5985
  to_port           = 5985
  cidr_ipv4         = "0.0.0.0/0"
  description       = "to allow instance to connect to WinRM (HTTP)"
}

resource "aws_vpc_security_group_ingress_rule" "winrm-https" {
  security_group_id = aws_security_group.web-sg.id
  ip_protocol       = "tcp"
  from_port         = 5986
  to_port           = 5986
  cidr_ipv4         = "0.0.0.0/0"
  description       = "to allow instance to connect to WinRM (HTTPS)"
}

resource "aws_vpc_security_group_ingress_rule" "RDP" {
  security_group_id = aws_security_group.web-sg.id
  ip_protocol       = "tcp"
  from_port         = 3389
  to_port           = 3389
  cidr_ipv4         = "0.0.0.0/0"
  description       = "to allow instance to connect to RDP"
}

resource "aws_vpc_security_group_ingress_rule" "jenkins" {
  security_group_id = aws_security_group.web-sg.id
  ip_protocol       = "tcp"
  from_port         = 8080
  to_port           = 8080
  cidr_ipv4         = "0.0.0.0/0"
  description       = "to allow instance to connect to jenkins"
}

resource "aws_vpc_security_group_ingress_rule" "iis" {
  security_group_id = aws_security_group.web-sg.id
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"
  description       = "to allow instance to connect to iis"
}

resource "aws_vpc_security_group_ingress_rule" "SSH" {
  security_group_id = aws_security_group.web-sg.id
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = "0.0.0.0/0"
  description       = "to allow instance to connect to SSH"
}


