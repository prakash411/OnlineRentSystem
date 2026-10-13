output "aws_key_name" {
  value = aws_key_pair.ec2-key.key_name
}

output "private_key" {
  value = local_file.my_private_key.content
}

output "vpc_id" {
  value = data.aws_vpc.default.id
}

output "region" {
  value = data.aws_region.current.region
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "iam_profile" {
  value = aws_iam_instance_profile.ec2-profile.name
}

output "codedeploy_role_arn" {
  value = aws_iam_role.CodeDeployRole.arn
}

output "route53_hosted_zone_id" {
  value = aws_route53_zone.private.zone_id
}