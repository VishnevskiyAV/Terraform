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


resource "aws_security_group" "web_access" {
  name        = "WebServer Security Group"
  description = "My First Security Group"

  dynamic "ingress" {             # используем динамический блок кода
    for_each = ["80", "443", "8080", "3389", "1541"] # используем цикл
    content {                     # определяем для чего используем динамический блок кода
      from_port   = ingress.value # подставляем значения из цикла
      to_port     = ingress.value # подставляем значения из цикла
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  ingress {                       # так как в динамическом блоке используется cidr_blocks 0, а нам к примеру надо определить другой
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.10.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Any traffic in all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name  = "Dynamic Security Group"
    Owner = "AV"
  }
}
