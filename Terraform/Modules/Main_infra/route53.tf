resource "aws_route53_zone" "private" {
  name = "internal.renter.com"

  vpc {
    vpc_id = data.aws_vpc.default.id
    vpc_region = data.aws_region.current.region
  }

  
}