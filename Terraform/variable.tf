variable "vpc-infra-object" {
  type = object({
    renter-vpc-object = object({
      vpc_name             = string
      vpc_cidr_block       = string
      enable_dns_support   = bool
      enable_dns_hostnames = bool
    })
    public-subnet-1-object = object({
      subnet_name             = string
      subnet_cidr_block       = string
      availability_zone       = string
      map_public_ip_on_launch = bool
    })
    private-subnet-1-object = object({
      subnet_name             = string
      subnet_cidr_block       = string
      availability_zone       = string
      map_public_ip_on_launch = bool
    })
    other-vpc-objects = object({
      public_route_table_name  = string
      private_route_table_name = string
      internet_gateway_name    = string
      elastic_ip_name          = string
      nat_gateway              = string
    })
  })
}

variable "route53_zone_name" {
  type = string
}

variable "jenkins-ec2_name" {
  type = string
}

variable "jenkins-sg-ingress-rules" {
  type = list(
    object({
      ip_protocol = string
      from_port   = number
      to_port     = number
      cidr_ipv4   = string
      description = string
    })
  )
}

variable "sonarqube-ec2_name" {
  type = string
}

variable "sonarqube-sg-ingress-rules" {
  type = list(
    object({
      ip_protocol = string
      from_port   = number
      to_port     = number
      cidr_ipv4   = string
      description = string
    })
  )
}

variable "web-ec2_name" {
  type = string
}

variable "web-sg-ingress-rules" {
  type = list(
    object({
      ip_protocol = string
      from_port   = number
      to_port     = number
      cidr_ipv4   = string
      description = string
    })
  )
}

variable "codedeploy-object" {
  type = object({
    codedeploy_platform    = string
    codedeploy_app_name    = string
    deployment_group_name  = string
    deployment_type        = string
    ec2_tag_type           = string
    ec2_tag_key            = string
    ec2_tag_value          = string
    deployment_config_type = string
  })
}

variable "db-ec2_name" {
  type = string
}

variable "db-sg-ingress-rules" {
  type = list(
    object({
      ip_protocol                  = string
      from_port                    = number
      to_port                      = number
      cidr_ipv4                    = optional(string)
      referenced_security_group_id = optional(string)
      description                  = string
    })
  )
}

variable "db-route53-object" {
  type = object({
    name = string
    type = string
    ttl  = number
  })
}




variable "amazon_ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "windows_ami" {
  type = string
}

