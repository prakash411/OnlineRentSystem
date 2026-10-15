resource "aws_security_group" "jenkins-sg" {
  name        = var.jenkins-sg-object.sg_name
  description = var.jenkins-sg-object.sg_description
  vpc_id      = var.jenkins-sg-object.vpc_id
  egress {
    protocol    = "ALL"
    from_port   = "0"
    to_port     = "0"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc_security_group_ingress_rule" "jenkins_ingress_rules" {
  security_group_id = aws_security_group.jenkins-sg.id
  for_each = {
    for rule in var.jenkins-sg-object.ingress_rules :
    "${rule.description}" => rule
  }
  ip_protocol = each.value.ip_protocol
  from_port   = each.value.from_port
  to_port     = each.value.to_port
  cidr_ipv4   = each.value.cidr_ipv4
  description = each.key
}



