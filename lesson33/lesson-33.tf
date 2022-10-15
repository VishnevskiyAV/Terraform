# ___________________________________________________
# My Terraform
#
# Terraform: Import resources
#
# Made by AV
# ___________________________________________________

provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "import_server" {
  ami           = "ami-05ff5eaef6149df49"
  instance_type = "t2.micro"
  tags = {
    "Name" = "Terraform import"
  }
}

resource "aws_security_group" "import_group" {
  description = "launch-wizard-1 created 2022-10-14T15:41:14.146Z"

  dynamic "ingress" {
    for_each = ["22", "443", "80"]
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
