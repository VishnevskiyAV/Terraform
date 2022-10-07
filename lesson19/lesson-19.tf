# ___________________________________________________
# My Terraform
#
# Variables
#
# Made by AV
# ___________________________________________________

provider "aws" {
  region = var.region
}

data "aws_ami" "latest_amazon_linux" {
  owners      = ["137112412989"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
  }
}

/*                                                  # Стоит денег поэтому не использую
resource "aws_eip" "my_static_ip" {
  instance = aws_instance.my_webserver.id
  tags = merge(var.common_tags, { Name = "${var.common_tags["Environment"]}-Server IP" })
}
*/

resource "aws_instance" "my_server" {
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.server_access.id] # Привязали Security Group к нашему instance
  monitoring             = var.enable_detailed_monitoring        # ежеминутная отправка статистики, но стоит дополнительных денег
  #tags = var.common_tags
  tags = merge(var.common_tags, { Name = "${var.common_tags["Environment"]}-Server" })
}

resource "aws_security_group" "server_access" {
  name = "Server Security Group"

  dynamic "ingress" {
    for_each = var.allow_ports
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
  tags = merge(var.common_tags, { Name = "${var.common_tags["Environment"]}-Server SG" })
}
