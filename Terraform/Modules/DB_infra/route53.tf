resource "aws_route53_record" "db_route53_record" {
  zone_id = var.db-route53-object.route53_hosted_zone_id
  name    = var.db-route53-object.name
  type    = var.db-route53-object.type
  ttl     = var.db-route53-object.ttl
  records = ["${aws_instance.db-server-ec2.private_ip}"]
}