terraform {
  backend "s3" {
    bucket = "tf-state-backend-bucket-661193795121"
    key    = "terraform.tfstate"
    region = "us-east-1"
    use_lockfile = true
  }
}