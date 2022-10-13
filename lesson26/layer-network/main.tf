# ___________________________________________________
# My Terraform
#
# Terraform Remote State
#
# Made by AV
# ___________________________________________________

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

# Variables
variable "vpx_cidr" {
  default = "10.0.0.0/16"
}

variable "env" {
  default = "dev"
}

variable "public_subnet_cidrs" {
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]
}

# Data
data "aws_availability_zones" "available" {}

# VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpx_cidr
  tags = {
    Name = "${var.env}-vpc"
  }
}

# Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.env}-igw"
  }
}

# Subnets
resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.public_subnet_cidrs, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.env}-public-${count.index + 1}"
  }
}

# Route table
resource "aws_route_table" "public_subnets" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "${var.env}-route-public-subnets"
  }
}

# Route table attach

resource "aws_route_table_association" "public_routes" {
  count          = length(aws_subnet.public_subnets[*].id)
  route_table_id = aws_route_table.public_subnets.id
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
}

