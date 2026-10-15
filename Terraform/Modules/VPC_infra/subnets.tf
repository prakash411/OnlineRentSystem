resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.renter_vpc.id
  cidr_block              = var.public-subnet-1-object.subnet_cidr_block
  availability_zone       = var.public-subnet-1-object.availability_zone
  map_public_ip_on_launch = var.public-subnet-1-object.map_public_ip_on_launch

  tags = {
    Name = var.public-subnet-1-object.subnet_name
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id                  = aws_vpc.renter_vpc.id
  cidr_block              = var.private-subnet-1-object.subnet_cidr_block
  availability_zone       = var.private-subnet-1-object.availability_zone
  map_public_ip_on_launch = var.private-subnet-1-object.map_public_ip_on_launch

  tags = {
    Name = var.private-subnet-1-object.subnet_name
  }
}