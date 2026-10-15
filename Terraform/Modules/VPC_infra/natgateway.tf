resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = var.other-vpc-objects.elastic_ip_name
  }

}

resource "aws_nat_gateway" "renter_nat" {
  subnet_id         = aws_subnet.public_subnet_1.id
  connectivity_type = "public"
  allocation_id     = aws_eip.nat_eip.id

  tags = {
    Name = var.other-vpc-objects.nat_gateway
  }

}