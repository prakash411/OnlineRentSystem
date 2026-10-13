resource "aws_route53_record" "db_record" {
  zone_id = var.route53_hosted_zone_id
  name    = "db.internal.renter.com"
  type    = "A"
  ttl     = 300
  records = ["${aws_instance.db-server-ec2.private_ip}"]
}