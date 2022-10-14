provider "aws" {
  region = "eu-central-1"
}

# Remote state s3 Bucket
terraform {
  backend "s3" {
    bucket = "vishnevskiyav.terraform"
    key    = "dev/network/terraform.tfstate"
    region = "eu-central-1"
  }
}

module "vpc-default" {
  source = "../modules/aws_net"
}

module "vpc-dev" {
  source              = "github.com/VishnevskiyAV/Terraform/lesson27-28/modules/aws_net"
  env                 = "development"
  vpc_cidr            = "10.100.0.0/16"
  public_subnet_cidrs = ["10.100.1.0/24", "10.100.2.0/24"]
  #private_subnet_cidrs = ["10.100.11.0/24", "10.100.22.0/24"]
}
