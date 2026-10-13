resource "aws_codedeploy_app" "codedeploy_app" {
  compute_platform = "Server"
  name             = "my_app"
}

resource "aws_codedeploy_deployment_group" "codedeploy_group" {
  app_name = aws_codedeploy_app.codedeploy_app.name
  deployment_group_name = "my_app_group"
  service_role_arn = var.codedeploy_role_arn
  deployment_style {
    deployment_type   = "IN_PLACE"
  }
  ec2_tag_set {
    ec2_tag_filter {
      type  = "KEY_AND_VALUE"
      key   = "Name"
      value = var.ec2_name
    }
  }  
  deployment_config_name = "CodeDeployDefault.OneAtATime"
}