resource "aws_route53_zone" "private" {
  name = var.main-infra-object.route53_zone_name

  vpc {
    vpc_id     = var.main-infra-object.vpc_id
    vpc_region = var.main-infra-object.vpc_region
  }


}