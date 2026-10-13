terraform {
  backend "s3" {
    bucket = "tf-state-backend-bucket-905418195910"
    key    = "terraform.tfstate"
    region = "us-east-1"
    use_lockfile = true
  }
}