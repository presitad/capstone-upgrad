# variables not allowed here
terraform {
  backend "s3" {
    bucket = "capstone-project-21"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}