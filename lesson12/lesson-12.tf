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
/*                                               # Стоит денег поэтому не использую
resource "aws_eip" "my_static_ip" {
  instance = aws_instance.my_webserver.id
}
*/
resource "aws_instance" "my_webserver" {
  ami                    = "ami-05ff5eaef6149df49" # Amazon Linux AMI
  instance_type          = "t2.micro"
  key_name               = "Frankfurt-vish"
  vpc_security_group_ids = [aws_security_group.web_access.id] # Привязали Security Group к нашему instance
  user_data = templatefile("D:/Учеба/Terraform/code/lesson12/user_data.tftpl", {
    f_name = "Aleksandr",
    l_name = "Vishnevskiy",
    names  = ["Alex", "Vanya", "Maria", "Vasya", "Olya"]
  })
  tags = {
    Name  = "Terraform"
    Owner = "AV"
  }

  lifecycle {
    prevent_destroy       = true
    ignore_changes        = ["ami"]
    create_before_destroy = true
  }
}

resource "aws_security_group" "web_access" {
  name        = "WebServer Security Group"
  description = "My First Security Group"

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
    Owner = "AV"
  }
}
