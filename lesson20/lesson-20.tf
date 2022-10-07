# ___________________________________________________
# My Terraform
#
# Local Variables
#
# Made by AV
# ___________________________________________________

provider "aws" {
  region = var.region
}

data "aws_region" "current" {}
data "aws_availability_zones" "available" {}

locals {
  az_list = join(",", data.aws_availability_zones.available.names) # переведем параметр из list в string, используя join, разделитель запятая
  reg     = data.aws_region.current.name
}

locals {
  full_project_name = "${var.environment}-${var.project}"
  project_owner     = "${var.owner} owner of ${var.project}"
}

resource "aws_eip" "Static_ip" {
  tags = {
    Name    = "Static IP"
    Owner   = local.project_owner
    Project = local.full_project_name
  }
}
