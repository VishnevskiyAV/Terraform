provider "aws" {
  region = "eu-central-1" // Region where to Create Resources
}

terraform {
  backend "s3" {
    bucket = "vishnevskiyav.terraform"    // Bucket where to SAVE Terraform State
    key    = "new-staging/terraform.tfstate" // Object name in the bucket to SAVE Terraform State
    region = "eu-central-1"                 // Region where bucket is created
  }
}
