resource "aws_iam_role" "ec2-ssm-role" {
  name = "ec2-ssm-role"
  assume_role_policy = jsonencode(
    {
      Version : "2012-10-17",
      Statement : [
        {
          Effect : "Allow",
          Principal : {
            Service : "ec2.amazonaws.com"
          },
          Action : "sts:AssumeRole"
        }
      ]
    }
  )
  tags = {
    Name        = "ec2-ssm-role"
    Environment = "dev"
  }
}

resource "aws_iam_role_policy_attachment" "ec2-policy-attachment" {
  role = aws_iam_role.ec2-ssm-role.name
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AWSCodeDeployFullAccess"
  ])
  policy_arn = each.value
}

resource "aws_iam_instance_profile" "ec2-profile" {
  name = "ec2-ssm-role"
  role = aws_iam_role.ec2-ssm-role.name
}

resource "aws_iam_role" "CodeDeployRole" {
  name = "CodeDeployRole"
  assume_role_policy = jsonencode(
    {
      Version : "2012-10-17",
      Statement : [
        {
          Effect : "Allow",
          Principal : {
            Service : "codedeploy.amazonaws.com"
          },
          Action : "sts:AssumeRole"
        }
      ]
    }
  )
  tags = {
    Name        = "CodeDeployRole"
    Environment = "dev"
  }
}

resource "aws_iam_role_policy_attachment" "codedeploy-policy-attachment" {
  role = aws_iam_role.CodeDeployRole.name
  for_each = toset([
    "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::${var.main-infra-object.account_id}:policy/AWSIAMWithDateConditions"
  ])
  policy_arn = each.value
}



