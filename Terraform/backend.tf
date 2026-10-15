terraform {
  backend "s3" {
    bucket       = "tf-state-backend-bucket-911167893459"
    key          = "terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}