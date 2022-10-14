provider "aws" {
  region = "eu-central-1"
}

# Remote state s3 Bucket
terraform {
  backend "s3" {
    bucket = "vishnevskiyav.terraform"
    key    = "dev/servers/terraform.tfstate"
    region = "eu-central-1"
  }
}

# Usage of remote state data
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "vishnevskiyav.terraform"
    key    = "dev/network/terraform.tfstate"
    region = "eu-central-1"
  }
}

# latest amazon linux ami
data "aws_ami" "latest_amazon_linux" {
  owners      = ["137112412989"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
  }
}

# Server
resource "aws_instance" "webserver" {
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.webserver.id]
  subnet_id              = data.terraform_remote_state.network.outputs.public_subnet_id[0]
  user_data              = file("user_data.sh")
  key_name               = "Frankfurt-vish"
  tags = {
    Name = "Web-server"
  }
}

# Security group
resource "aws_security_group" "webserver" {
  name   = "Webserver security group"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.network.outputs.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "web-server-sg"
    Owner = "AV"
  }
}
