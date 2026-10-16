locals {
  jenkins_bucket_name = format("jenkins-bucket-%s-%s", data.aws_caller_identity.current.account_id, data.aws_region.current.region)
}

module "vpc_infra" {
  source                  = "./Modules/VPC_infra"
  renter-vpc-object       = var.vpc-infra-object.renter-vpc-object
  public-subnet-1-object  = var.vpc-infra-object.public-subnet-1-object
  private-subnet-1-object = var.vpc-infra-object.private-subnet-1-object
  other-vpc-objects       = var.vpc-infra-object.other-vpc-objects

}

module "main_infra" {
  source = "./Modules/main_infra"
  main-infra-object = {
    route53_zone_name = var.default-objects.route53_zone_name
    vpc_id            = module.vpc_infra.renter-vpc-id
    vpc_region        = data.aws_region.current.region
    account_id        = data.aws_caller_identity.current.account_id
  }
  depends_on = [module.vpc_infra]
}


module "jenkins_infra" {
  source = "./Modules/Jenkins_infra"
  jenkins-ec2-object = {
    ami           = var.default-objects.amazon_linux_ami
    instance_type = var.default-objects.instance_type
    aws_key       = module.main_infra.aws_key_name
    private_key   = module.main_infra.private_key
    ec2_name      = "${var.default-objects.jenkins}-server"
    subnet_id     = module.vpc_infra.renter-public-subnet-id
    iam_profile   = module.main_infra.iam_profile
    bucket_name   = local.jenkins_bucket_name
  }
  jenkins-sg-object = {
    sg_name        = "${var.default-objects.jenkins}-sg"
    sg_description = "this sg allow for ${var.default-objects.jenkins}-server"
    vpc_id         = module.vpc_infra.renter-vpc-id
    ingress_rules  = var.jenkins-sg-ingress-rules
  }
  depends_on = [module.main_infra]
}


module "sonarqube_infra" {
  source = "./Modules/Sonarqube_infra"
  sonarqube-ec2-object = {
    ami           = var.default-objects.amazon_linux_ami
    instance_type = var.default-objects.instance_type
    aws_key       = module.main_infra.aws_key_name
    private_key   = module.main_infra.private_key
    ec2_name      = "${var.default-objects.sonarqube}-server"
    subnet_id     = module.vpc_infra.renter-public-subnet-id
    iam_profile   = module.main_infra.iam_profile
  }
  sonarqube-sg-object = {
    sg_name        = "${var.default-objects.sonarqube}-sg"
    sg_description = "this sg allow for ${var.default-objects.sonarqube}-server"
    vpc_id         = module.vpc_infra.renter-vpc-id
    ingress_rules  = var.sonarqube-sg-ingress-rules
  }
  depends_on = [module.main_infra, module.jenkins_infra]
}

module "web_infra" {
  source = "./Modules/Web_infra"
  web-ec2-object = {    
    ami           = var.default-objects.windows_ami
    instance_type = var.default-objects.instance_type
    aws_key       = module.main_infra.aws_key_name
    private_key   = module.main_infra.private_key
    ec2_name      = "${var.default-objects.web}-server"
    subnet_id     = module.vpc_infra.renter-public-subnet-id
    iam_profile   = module.main_infra.iam_profile
  }
  web-sg-object = {
    sg_name        = "${var.default-objects.web}-sg"
    sg_description = "this sg allow for ${var.default-objects.web}-server"
    vpc_id         = module.vpc_infra.renter-vpc-id
    ingress_rules  = var.web-sg-ingress-rules
  }
  codedeploy-object = {
    codedeploy_platform    = var.codedeploy-object.codedeploy_platform
    codedeploy_app_name    = var.codedeploy-object.codedeploy_app_name
    deployment_group_name  = var.codedeploy-object.deployment_group_name
    deployment_type        = var.codedeploy-object.deployment_type
    codedeploy_role_arn    = module.main_infra.codedeploy_role_arn
    ec2_tag_type           = var.codedeploy-object.ec2_tag_type
    ec2_tag_key            = var.codedeploy-object.ec2_tag_key
    ec2_tag_value          = var.codedeploy-object.ec2_tag_value
    deployment_config_type = var.codedeploy-object.deployment_config_type
  }
  depends_on = [
    module.main_infra, module.jenkins_infra
  ]
}

module "db_infra" {
  source = "./Modules/DB_infra"
  db-ec2-object = {    
    ami           = var.default-objects.windows_ami
    instance_type = var.default-objects.instance_type
    aws_key       = module.main_infra.aws_key_name
    private_key   = module.main_infra.private_key
    ec2_name      = "${var.default-objects.db}-server"
    subnet_id     = module.vpc_infra.renter-private-subnet-id
    iam_profile   = module.main_infra.iam_profile
  }
  db-sg-object = {
    sg_name        = "${var.default-objects.db}-sg"
    sg_description = "this sg allow for ${var.default-objects.db}-server"
    vpc_id         = module.vpc_infra.renter-vpc-id
    ingress_rules = concat(
      [
        {
          ip_protocol                  = "tcp"
          from_port                    = 3306
          to_port                      = 3306
          cidr_ipv4                    = null
          referenced_security_group_id = module.web_infra.web_security_group_id
          description                  = "allow MySQL access from the web tier"
        }
      ],
      var.db-sg-ingress-rules
    )
  }
  db-route53-object = {
    route53_hosted_zone_id = module.main_infra.route53_hosted_zone_id
    name                   = var.db-route53-object.name
    type                   = var.db-route53-object.type
    ttl                    = var.db-route53-object.ttl
  }
  depends_on = [
    module.main_infra, module.jenkins_infra, module.web_infra
  ]
}