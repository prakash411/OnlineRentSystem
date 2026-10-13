resource "aws_security_group" "db-sg" {
  name        = "db-sg"
  description = "this sg allow for db servers"
  vpc_id = var.vpc_id
  egress {
    protocol    = "ALL"
    from_port   = "0"
    to_port     = "0"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc_security_group_ingress_rule" "MySQL" {
  security_group_id = aws_security_group.db-sg.id
  ip_protocol       = "tcp"
  from_port         = 3306
  to_port           = 3306
  cidr_ipv4         = "0.0.0.0/0"
  description       = "to allow instance to connect to MySQL"
}

resource "aws_vpc_security_group_ingress_rule" "RDP" {
  security_group_id = aws_security_group.db-sg.id
  ip_protocol       = "tcp"
  from_port         = 3389
  to_port           = 3389
  cidr_ipv4         = "0.0.0.0/0"
  description       = "to allow instance to connect to RDP"
}

resource "aws_vpc_security_group_ingress_rule" "SSH" {
  security_group_id = aws_security_group.db-sg.id
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = "0.0.0.0/0"
  description       = "to allow instance to connect to SSH"
}


