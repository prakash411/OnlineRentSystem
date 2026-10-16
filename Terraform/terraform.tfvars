vpc-infra-object = {
  renter-vpc-object = {
    vpc_name             = "renter-vpc"
    vpc_cidr_block       = "10.0.0.0/16"
    enable_dns_support   = true
    enable_dns_hostnames = true
  }

  public-subnet-1-object = {
    subnet_name             = "public-subnet-1"
    subnet_cidr_block       = "10.0.1.0/24"
    availability_zone       = "us-east-1a"
    map_public_ip_on_launch = true
  }

  private-subnet-1-object = {
    subnet_name             = "private-subnet-1"
    subnet_cidr_block       = "10.0.2.0/24"
    availability_zone       = "us-east-1a"
    map_public_ip_on_launch = false
  }

  other-vpc-objects = {
    public_route_table_name  = "public-rt"
    private_route_table_name = "private-rt"
    internet_gateway_name    = "renter-igw"
    elastic_ip_name          = "renter-nat-eip"
    nat_gateway              = "renter-nat"
  }
}

default-objects = {
  windows_ami        = "ami-00d8aa800578d8b12"
  amazon_linux_ami         = "ami-081b0a6eac00b4f53"
  instance_type      = "t3.medium"
  jenkins   = "jenkins"
  sonarqube = "sonarqube"
  web       = "web"
  db        = "db" 
  route53_zone_name  = "internal.renter.com"
}


jenkins-sg-ingress-rules = [
  {
    ip_protocol = "tcp"
    from_port   = 9000
    to_port     = 9000
    cidr_ipv4   = "0.0.0.0/0"
    description = "to allow instance to connect to SonarQube"
  },
  {
    ip_protocol = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_ipv4   = "0.0.0.0/0"
    description = "to allow instance to connect to jenkins"
  },
  {
    ip_protocol = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_ipv4   = "0.0.0.0/0"
    description = "to allow instance to connect to SSH"
  }
]

sonarqube-sg-ingress-rules = [
  {
    ip_protocol = "tcp"
    from_port   = 9000
    to_port     = 9000
    cidr_ipv4   = "0.0.0.0/0"
    description = "to allow instance to connect to SonarQube"
  },
  {
    ip_protocol = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_ipv4   = "0.0.0.0/0"
    description = "to allow instance to connect to jenkins"
  },
  {
    ip_protocol = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_ipv4   = "0.0.0.0/0"
    description = "to allow instance to connect to SSH"
  }
]

web-sg-ingress-rules = [
  {
    ip_protocol = "tcp"
    from_port   = 3389
    to_port     = 3389
    cidr_ipv4   = "0.0.0.0/0"
    description = "to allow instance to connect to RDP"
  },
  {
    ip_protocol = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_ipv4   = "0.0.0.0/0"
    description = "to allow instance to connect to jenkins"
  },
  {
    ip_protocol = "tcp"
    from_port   = 8080
    to_port     = 8080
    cidr_ipv4   = "0.0.0.0/0"
    description = "to allow instance to connect to iis"
  },
  {
    ip_protocol = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_ipv4   = "0.0.0.0/0"
    description = "to allow instance to connect to SSH"
  }
]

codedeploy-object = {
  codedeploy_platform    = "Server"
  codedeploy_app_name    = "my_app"
  deployment_group_name  = "my_app_group"
  deployment_type        = "IN_PLACE"
  ec2_tag_type           = "KEY_AND_VALUE"
  ec2_tag_key            = "Name"
  ec2_tag_value          = "web-server"
  deployment_config_type = "CodeDeployDefault.OneAtATime"
}

db-sg-ingress-rules = [
  {
    ip_protocol                  = "tcp"
    from_port                    = 3389
    to_port                      = 3389
    cidr_ipv4                    = "0.0.0.0/0"
    referenced_security_group_id = null
    description                  = "to allow instance to connect to RDP"
  },
  {
    ip_protocol                  = "tcp"
    from_port                    = 22
    to_port                      = 22
    cidr_ipv4                    = "0.0.0.0/0"
    referenced_security_group_id = null
    description                  = "to allow instance to connect to SSH"
  }
]


db-route53-object = {
  name = "db.internal.renter.com"
  type = "A"
  ttl  = 300
}