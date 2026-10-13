resource "aws_security_group" "jenkins-sg" {
  name        = "jenkins-sg"
  description = "this sg allow for jenkins servers"
  vpc_id = var.vpc_id
  egress {
    protocol    = "ALL"
    from_port   = "0"
    to_port     = "0"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc_security_group_ingress_rule" "SonarQube" {
  security_group_id = aws_security_group.jenkins-sg.id
  ip_protocol       = "tcp"
  from_port         = 9000
  to_port           = 9000
  cidr_ipv4         = "0.0.0.0/0"
  description       = "to allow instance to connect to SonarQube"
}

resource "aws_vpc_security_group_ingress_rule" "jenkins" {
  security_group_id = aws_security_group.jenkins-sg.id
  ip_protocol       = "tcp"
  from_port         = 8080
  to_port           = 8080
  cidr_ipv4         = "0.0.0.0/0"
  description       = "to allow instance to connect to jenkins"
}

resource "aws_vpc_security_group_ingress_rule" "SSH" {
  security_group_id = aws_security_group.jenkins-sg.id
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = "0.0.0.0/0"
  description       = "to allow instance to connect to SSH"
}



