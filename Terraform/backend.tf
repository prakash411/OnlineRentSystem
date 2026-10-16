terraform {
  backend "s3" {
    bucket       = "tf-state-backend-bucket-637423470040-637423470040-us-east-1-an"
    key          = "terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}