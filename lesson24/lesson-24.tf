# ___________________________________________________
# My Terraform
#
# Terraform loops: Count and for if
#
# Made by AV
# ___________________________________________________

provider "aws" {
  region = "eu-central-1"
}

variable "aws_user" {
  description = "List of users"
  default     = ["vasya", "petya", "kolya", "lena", "misha"]
}

resource "aws_iam_user" "user1" {
  name = "test"
}

resource "aws_iam_user" "users" {
  count = length(var.aws_user)               # length возвращает длину массива
  name  = element(var.aws_user, count.index) # функция element принимает 2 параметра (значение и количество)
}
# ___________________________________________________

resource "aws_instance" "servers" {
  count         = 3
  ami           = "ami-05ff5eaef6149df49"
  instance_type = "t2.micro"
  tags = {
    Name = "Server Number ${count.index + 1}"
  }
}

# ___________________________________________________

output "created_iam_users_all" {
  value = aws_iam_user.users
}

output "created_iam_users_id" {
  value = aws_iam_user.users[*].id
}

output "created_iam_users_id_arn" {
  value = [
    for i in aws_iam_user.users :
    "Username: ${i.name} has Arn: ${i.arn}"
  ]
}

output "created_iam_users_map" {
  value = {
    for user in aws_iam_user.users :
    user.unique_id => user.id # => - выведется как равно, если нужен дополнительный текст, то как в примере выше
  }
}

output "created_iam_users_if_length" {
  value = [
    for i in aws_iam_user.users :
    i.name                 # получение переменной name
    if length(i.name) == 4 # условие 4 characters only
  ]
}

output "server_all" {
  value = {
    for i in aws_instance.servers :
    i.id => i.public_ip
  }
}
