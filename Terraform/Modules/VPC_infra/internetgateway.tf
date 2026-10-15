resource "aws_internet_gateway" "renter_igw" {
  vpc_id = aws_vpc.renter_vpc.id

  tags = {
    Name = var.other-vpc-objects.internet_gateway_name
  }
}