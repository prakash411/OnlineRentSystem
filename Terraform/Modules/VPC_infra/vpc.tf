resource "aws_vpc" "renter_vpc" {
  cidr_block           = var.renter-vpc-object.vpc_cidr_block
  enable_dns_support   = var.renter-vpc-object.enable_dns_support
  enable_dns_hostnames = var.renter-vpc-object.enable_dns_hostnames

  tags = {
    Name = var.renter-vpc-object.vpc_name
  }
}