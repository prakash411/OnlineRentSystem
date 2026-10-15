output "renter-vpc-id" {
  value = aws_vpc.renter_vpc.id
}

output "renter-public-subnet-id" {
  value = aws_subnet.public_subnet_1.id
}

output "renter-private-subnet-id" {
  value = aws_subnet.private_subnet_1.id
}