# ___________________________________________________
# My Terraform
#
# Build WevServer during Bootstrap
#
# Made by AV
# ___________________________________________________

provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "web_server" {
  ami                    = "ami-05ff5eaef6149df49" # Amazon Linux AMI
  instance_type          = "t2.micro"
  key_name               = "Frankfurt-vish"
  vpc_security_group_ids = [aws_security_group.web_access.id] # Привязали Security Group к нашему instance

  tags = {
    Name  = "Terraform_web"
    Owner = "AV"
  }
    depends_on = [
    aws_instance.db_server,
    aws_instance.app_server
  ]
}

resource "aws_instance" "app_server" {
  ami                    = "ami-05ff5eaef6149df49" # Amazon Linux AMI
  instance_type          = "t2.micro"
  key_name               = "Frankfurt-vish"
  vpc_security_group_ids = [aws_security_group.web_access.id] # Привязали Security Group к нашему instance

  tags = {
    Name  = "Terraform_app"
    Owner = "AV"
  }
  depends_on = [
    aws_instance.db_server
  ]

}

resource "aws_instance" "db_server" {
  ami                    = "ami-05ff5eaef6149df49" # Amazon Linux AMI
  instance_type          = "t2.micro"
  key_name               = "Frankfurt-vish"
  vpc_security_group_ids = [aws_security_group.web_access.id] # Привязали Security Group к нашему instance

  tags = {
    Name  = "Terraform_db"
    Owner = "AV"
  }

}


resource "aws_security_group" "web_access" {
  name        = "WebServer Security Group"

  dynamic "ingress" {
    for_each = ["80", "443", "22"]
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
    protocol    = "-1" # Any traffic in all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name  = "Terraform"
  }
}
