variable "db-ec2-object" {
  type = object({
    ami           = string
    instance_type = string
    aws_key       = string
    private_key   = string
    ec2_name      = string
    subnet_id     = string
    iam_profile   = string
  })
}

variable "db-sg-object" {
  type = object({
    sg_name        = string
    sg_description = string
    vpc_id         = string
    ingress_rules = list(
      object({
        ip_protocol                  = string
        from_port                    = number
        to_port                      = number
        cidr_ipv4                    = optional(string)
        referenced_security_group_id = optional(string)
        description                  = string
      })
    )
  })
}

variable "db-route53-object" {
  type = object({
    route53_hosted_zone_id = string
    name                   = string
    type                   = string
    ttl                    = number
  })
}
