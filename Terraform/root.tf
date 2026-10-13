module "main_infra" {
  source = "./Modules/main_infra"
}


module "jenkins_infra" {
  source = "./Modules/Jenkins_infra"
  aws_key = module.main_infra.aws_key_name
  private_key = module.main_infra.private_key
  ec2_name = "Jenkins Server"
  ami = var.amazon_ami
  instance_type = var.instance_type
  iam_profile = module.main_infra.iam_profile
  vpc_id = module.main_infra.vpc_id
  bucket_name = format("jenkins-bucket-%s-%s", module.main_infra.account_id, module.main_infra.region)
  depends_on = [ module.main_infra ]
}

module "sonarqube_infra" {
  source = "./Modules/Sonarqube_infra"
  aws_key = module.main_infra.aws_key_name
  private_key = module.main_infra.private_key
  ec2_name = "SonarQube Server"
  ami = var.amazon_ami
  instance_type = var.instance_type
  iam_profile = module.main_infra.iam_profile
  vpc_id = module.main_infra.vpc_id
  depends_on = [ module.main_infra, module.jenkins_infra ]
}

module "web_infra" {
  source = "./Modules/Web_infra"
  aws_key = module.main_infra.aws_key_name
  private_key = module.main_infra.private_key
  ec2_name = "Web Server"
  ami = var.windows_ami
  instance_type = var.instance_type
  iam_profile = module.main_infra.iam_profile
  vpc_id = module.main_infra.vpc_id
  codedeploy_role_arn = module.main_infra.codedeploy_role_arn
  depends_on = [
    module.main_infra
  ]
}

module "db_infra" {
  source = "./Modules/DB_infra"
  aws_key = module.main_infra.aws_key_name
  private_key = module.main_infra.private_key
  ec2_name = "DB Server"
  ami = var.windows_ami
  instance_type = var.instance_type
  iam_profile = module.main_infra.iam_profile
  vpc_id = module.main_infra.vpc_id
  route53_hosted_zone_id = module.main_infra.route53_hosted_zone_id
  depends_on = [
    module.main_infra
  ]
}