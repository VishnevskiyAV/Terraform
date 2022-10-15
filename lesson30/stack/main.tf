#----------------------------------------------------------
# My Terraform
#
# Use Global Variables from Remote State
#
# Made by AV
#----------------------------------------------------------

provider "aws" {
  region = "eu-central-1"
}

data "terraform_remote_state" "global" {
  backend = "s3"
  config = {
    bucket = "vishnevskiyav.terraform"
    key    = "globalvar/terraform.tfstate"
    region = "eu-central-1"
  }
}

locals {
  company = data.terraform_remote_state.global.outputs.company_name
  owner   = data.terraform_remote_state.global.outputs.owner
  tags    = data.terraform_remote_state.global.outputs.tags
}

resource "aws_vpc" "vpc-1" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name    = "Stack-VPC1"
    company = locals.company
    Owner   = locals.owner
  }
}

resource "aws_vpc" "vpc-2" {
  cidr_block = "10.1.0.0/16"
  tags       = merge(local.tags, { Name = "Stack-VPC2" })
}
