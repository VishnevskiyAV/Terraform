provider "aws" {
  region = "eu-central-1" 
}

terraform {
  backend "s3" {
    bucket = "vishnevskiyav.terraform"
    key    = "prod/terraform.tfstate" 
    region = "eu-central-1"              
  }
}
