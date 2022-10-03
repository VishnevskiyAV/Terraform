provider "aws" {
  region = "eu-central-1" # если в Linux то будет брать из Env. variables 
}

data "aws_availability_zones" "working" {} # Запрос доступных зон
data "aws_caller_identity" "current" {}    # Запрос id текущего пользователя
data "aws_region" "current" {}             # Запрос текущего региона
data "aws_vpcs" "my_vpcs" {}               # Запрос текущих vpc

data "aws_vpc" "prod_vpc" { # Запрос vpc по тагу
  tags = {
    Name = "prod"
  }
}

resource "aws_subnet" "prod_subnet_1" {
  vpc_id            = data.aws_vpc.prod_vpc.id    # Используем значения из data
  availability_zone = data.aws_availability_zones.working.names[0]  # Используем значения из data
  cidr_block        = "172.31.48.0/24"    
  tags = {
    Name    = "Subnet-1 in ${data.aws_availability_zones.working.names[0]}" # Используем значения из data
    Account = "Subnet-1 in ${data.aws_caller_identity.current.account_id}"  # Используем значения из data
    Region  = data.aws_region.current.description   # Используем значения из data
  }
}

resource "aws_subnet" "prod_subnet_2" {
  vpc_id            = data.aws_vpc.prod_vpc.id
  availability_zone = data.aws_availability_zones.working.names[1]
  cidr_block        = "172.31.49.0/24"
  tags = {
    Name    = "Subnet-2 in ${data.aws_availability_zones.working.names[1]}"
    Account = "Subnet-2 in ${data.aws_caller_identity.current.account_id}"
    Region  = data.aws_region.current.description
  }
}


output "AWS_tag_vpc" {
  value = data.aws_vpc.prod_vpc.id # Вызовет ID vpc по тагу
}

output "AWS_tag_CIDR" {
  value = data.aws_vpc.prod_vpc.cidr_block # Вызовет CIDR Block vpc по тагу
}

output "Data_AZ_1" {
  value = data.aws_availability_zones.working.names[1] # Вызовет только одно из имен (как в массиве)
}
output "Data_AZ_all" {
  value = data.aws_availability_zones.working.names # Вызовет все доступные зоны 
}

output "Caller_ID" {
  value = data.aws_caller_identity.current.account_id # Вызовет id текущего пользователя 
}

output "Region_name" {
  value = data.aws_region.current.description # Вызовет текущий регион (описание Europe (Frankfurt))
}

output "AWS_vpcs" {
  value = data.aws_vpcs.my_vpcs.ids # Вызовет все ID всех vpc в текущем регионе
}


