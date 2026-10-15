resource "aws_s3_bucket" "jenkins-bucket" {
  bucket = var.jenkins-ec2-object.bucket_name

}