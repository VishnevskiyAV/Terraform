#----------------------------------------------------------
# My Terraform
#
# Global Variables in Remote State on S3
#
# Made AV
#----------------------------------------------------------
provider "aws" {
  region = "eu-central-1"
}

terraform {
  backend "s3" {
    bucket = "vishnevskiyav.terraform"
    key    = "globalvar/terraform.tfstate"
    region = "eu-central-1"
  }
}

output "company_name" {
  value = "Intel"
}

output "owner" {
  value = "AV"
}

output "tags" {
    value = {
        Project = "All in one"
        Deployment = "dev"
        
    }
}
