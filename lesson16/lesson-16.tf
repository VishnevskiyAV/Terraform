#----------------------------------------------------------
# My Terraform
#
# Find latest AMI id of:
#      - Ubuntu 22.04
#      - Amazon Linux 2
#      - Windwos Server 2022 Base
#
#----------------------------------------------------------

provider "aws" {
    region = "eu-central-1"  
}


data "aws_ami" "Ubuntu_latest" {
    owners = ["099720109477"]
    most_recent = true
    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    }
}

data "aws_ami" "Amazon2_latest" {
    owners = ["137112412989"]
    most_recent = true
    filter {
        name = "name"
        values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
    }
}

data "aws_ami" "windows_latest" {
    owners = ["801119661308"]
    most_recent = true
    filter {
        name = "name"
        values = ["Windows_Server-2022-English-Full-Base-*"]
    }
  
}

output "Ubuntu_ami_id_latest" {
    value = data.aws_ami.Ubuntu_latest.id
}

output "Ubuntu_ami_name" {
    value = data.aws_ami.Ubuntu_latest.name
}

output "Amazon_ami_id_latest" {
    value = data.aws_ami.Amazon2_latest.id
}

output "Windows_ami_id_latest" {
    value = data.aws_ami.windows_latest.id
}