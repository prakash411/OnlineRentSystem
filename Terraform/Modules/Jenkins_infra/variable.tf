variable "ami" {
  type    = string
}

variable "instance_type" {
  type    = string
  default = "t3.medium"
}

variable "aws_key" {
  type = string
}

variable "private_key" {
  type = string
}

variable "ec2_name" {
  type = string
}

variable "bucket_name" {
  type = string  
}

variable "iam_profile" {
  type = string
}

variable "vpc_id" {
  type = string
}