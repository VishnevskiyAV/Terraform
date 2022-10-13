# ___________________________________________________
# My Terraform
#
# Provisioning Resources in Multiple AWS Regions / Accounts
#
# Made by AV
# ___________________________________________________

provider "aws" {
  region = "eu-central-1"
  alias  = "Europe"
  assume_role {
    role_arn     = "arn:aws:iam::<ACCOUNT ID>:role/......"
    session_name = "Terraform Session" # обязательно указать имя сессии (любое)
  }
}

provider "aws" {
  region = "ca-central-1"
  alias  = "Canada"
}

data "aws_ami" "latest_amazon_linux_def" {
  owners      = ["137112412989"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
  }
}

data "aws_ami" "latest_amazon_linux_Can" {
  provider    = aws.Canada
  owners      = ["137112412989"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "Frankfurt_server" {
  ami           = data.aws_ami.latest_amazon_linux_def.id
  instance_type = "t2.micro"
  tags = {
    Name = "Frankfurt server"
  }
}

resource "aws_instance" "Canada_server" {
  provider      = aws.Canada # Регион alias
  ami           = data.aws_ami.latest_amazon_linux_Can.id
  instance_type = "t2.micro"
  tags = {
    Name = "Canada server"
  }
}

