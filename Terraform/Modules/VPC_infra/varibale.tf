variable "renter-vpc-object" {
  type = object({
    vpc_name             = string
    vpc_cidr_block       = string
    enable_dns_support   = bool
    enable_dns_hostnames = bool
  })
}

variable "public-subnet-1-object" {
  type = object({
    subnet_name             = string
    subnet_cidr_block       = string
    availability_zone       = string
    map_public_ip_on_launch = bool
  })
}

variable "private-subnet-1-object" {
  type = object({
    subnet_name             = string
    subnet_cidr_block       = string
    availability_zone       = string
    map_public_ip_on_launch = bool
  })
}

variable "other-vpc-objects" {
  type = object({
    public_route_table_name  = string
    private_route_table_name = string
    internet_gateway_name    = string
    elastic_ip_name          = string
    nat_gateway              = string
  })
}