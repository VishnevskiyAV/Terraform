terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=3.25.0"
      configuration_aliases = [
        aws.root,
        aws.prod,
        aws.dev
      ]
    }
  }
}

data "aws_ami" "latest_amazon_linux_root" {
  provider    = aws.root
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

data "aws_ami" "latest_amazon_linux_prod" {
  provider    = aws.prod
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

data "aws_ami" "latest_amazon_linux_dev" {
  provider    = aws.dev
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

#_____________________________________________________________________

resource "aws_instance" "server_root" {
  provider      = aws.root
  ami           = data.aws_ami.latest_amazon_linux_root.id
  instance_type = var.instance_type
  tags          = { Name = "Server-root" }
}

resource "aws_instance" "server_prod" {
  provider      = aws.prod
  ami           = data.aws_ami.latest_amazon_linux_prod.id
  instance_type = var.instance_type
  tags          = { Name = "Server-prod" }
}

resource "aws_instance" "server_dev" {
  provider      = aws.dev
  ami           = data.aws_ami.latest_amazon_linux_dev.id
  instance_type = var.instance_type
  tags          = { Name = "Server-dev" }
}
