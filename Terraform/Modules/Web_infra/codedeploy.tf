resource "aws_codedeploy_app" "codedeploy_app" {
  compute_platform = var.codedeploy-object.codedeploy_platform
  name             = var.codedeploy-object.codedeploy_app_name
}

resource "aws_codedeploy_deployment_group" "web_codedeploy_group" {
  app_name              = aws_codedeploy_app.codedeploy_app.name
  deployment_group_name = var.codedeploy-object.deployment_group_name
  service_role_arn      = var.codedeploy-object.codedeploy_role_arn
  deployment_style {
    deployment_type = var.codedeploy-object.deployment_type
  }
  ec2_tag_set {
    ec2_tag_filter {
      type  = var.codedeploy-object.ec2_tag_type
      key   = var.codedeploy-object.ec2_tag_key
      value = var.codedeploy-object.ec2_tag_value
    }
  }
  deployment_config_name = var.codedeploy-object.deployment_config_type
}