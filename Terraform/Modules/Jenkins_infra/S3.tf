resource "aws_s3_bucket" "jenkins-bucket" {
  bucket = var.bucket_name
  
}