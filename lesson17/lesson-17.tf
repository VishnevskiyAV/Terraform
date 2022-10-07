#----------------------------------------------------------
# Provision Highly Availabe Web in any Region Default VPC
# Create:
#   - Security group for Web Server
#   - Launch Configuration with Auto AMI Lookup
#   - Auto Scaling Group using 2 Availability Zones
#   - Classic Load Balancer in 2 Availability Zones
#
# Usage
#   - After first creation of the tempalte infrastructure by using the dependecy in LA and ASG and the lifecycle, Blue/Green occures
#
# Made by Aleksandr Vishnevskiy 07-October-2022
#----------------------------------------------------------

provider "aws" {
  region = "eu-central-1"
}

data "aws_availability_zones" "available" {}
data "aws_ami" "latest_amazon_linux" {
  owners      = ["137112412989"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
  }
}

#----------------------------------------------------------
# Security group for Web Server

resource "aws_security_group" "security_group_webserver" {
  name = "Server-secutiry-group"

  dynamic "ingress" {
    for_each = ["80", "8080", "22", "443"]
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

  tags = {
    Name  = "Server-secutiry-group"
    Owner = "AV"
  }
}

# Launch Configuration with Auto AMI Lookup

resource "aws_launch_configuration" "web" {
  #  name            = "WEBServer-HA-LC"
  name_prefix     = "WEBServer-HA-LC"
  image_id        = data.aws_ami.latest_amazon_linux.id
  instance_type   = "t2.micro"
  key_name        = "Frankfurt-vish"
  security_groups = [aws_security_group.security_group_webserver.id]
  user_data       = file("user_data.sh")

  lifecycle {
    create_before_destroy = true
  }
}

# Auto Scaling Group using 2 Availability Zones

resource "aws_autoscaling_group" "web" {
  name                 = "ASG-${aws_launch_configuration.web.name}" # the coolest feature, in depend of LA it creates new ASG with lifecycle
  launch_configuration = aws_launch_configuration.web.name
  min_size             = 2
  max_size             = 2
  min_elb_capacity     = 2
  health_check_type    = "ELB"
  vpc_zone_identifier  = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  load_balancers       = [aws_elb.web.name]

  dynamic "tag" { # the example of dynamic tag usage
    for_each = {
      Name   = "WebServer in ASG"
      Owner  = "AV"
      TAGKEY = "TAGVALUE"
    }
    content {
      key                 = tag.key   # without quotes
      value               = tag.value # without quotes
      propagate_at_launch = true
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}

# Classic Load Balancer in 2 Availability Zones

resource "aws_elb" "web" {
  name               = "WebServer-HA-ELB" # no spaces, it will used for DNS name
  availability_zones = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]
  security_groups    = [aws_security_group.security_group_webserver.id]
  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = 80
    instance_protocol = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/" # check our web site health
    interval            = 10
  }
  tags = {
    Name = "WebServer-HA-LBA"
  }
}

resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.available.names[0]
}
resource "aws_default_subnet" "default_az2" {
  availability_zone = data.aws_availability_zones.available.names[1]
}
