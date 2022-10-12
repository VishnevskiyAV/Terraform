# ___________________________________________________
# My Terraform
#
# Terraform conditions and Lookups
#
# Made by AV
# ___________________________________________________


provider "aws" {
  region = "eu-central-1"
}

variable "env" { # Condition 
  default = "prod"
}

variable "prod_owner" { # Condition 
  default = "AV"
}

variable "non_prod_owner" { # Condition 
  default = "Aleksandr"
}

variable "ec2_size" { # Lookup 
  default = {
    "prod" = "t2.micro"
    "dev"  = "t3.micro"
    "test" = "t2.small"
  }
}

variable "allow_port_list" {
  default = {
    "prod" = ["80", "443"]
    "dev"  = ["80", "443", "8080", "22"]
  }
}

resource "aws_instance" "web_server" {
  ami = "ami-05ff5eaef6149df49"
  #instance_type = var.env == "prod" ? "t2.micro" : "t3.micro" # Condition 
  instance_type = var.env == "prod" ? var.ec2_size["prod"] : var.ec2_size["dev"]
  tags = {
    Name  = "${var.env}-server"
    Owner = var.env == "prod" ? var.prod_owner : var.non_prod_owner # Condition 
  }
}

resource "aws_instance" "bastion_host" {
  count         = var.env == "prod" ? 1 : 0 # Condition for count
  ami           = "ami-05ff5eaef6149df49"
  instance_type = "t2.micro"
  tags = {
    Name = "Bastion server"
  }
}

resource "aws_instance" "web2_server" {
  ami           = "ami-05ff5eaef6149df49"
  instance_type = lookup(var.ec2_size, var.env) # Lookup 
  tags = {
    Name  = "${var.env}-server"
    Owner = var.env == "prod" ? var.prod_owner : var.non_prod_owner
  }
}

resource "aws_security_group" "security_group_webserver" {
  name = "Server-secutiry-group"
  dynamic "ingress" {
    for_each = lookup(var.allow_port_list, var.env)
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
