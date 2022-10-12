provider "aws" {
  region = "eu-central-1"
}

variable "name" {
    default = "Admin"
}

resource "random_string" "rds_password" { # генерация пароля
  length           = 12                   # длинна пароля
  special          = true                 # использовать специальные символы
  override_special = "!#$&"               # какие специальные символы можно использовать при генерации пароля
  keepers = {
    kepper1 = var.name
  }
}

resource "aws_ssm_parameter" "rds_password" { # место хранения пароля
  name        = "/prod/mysql"
  description = "Master password for mysql"
  type        = "SecureString"                    # тип хранимой строки
  value       = random_string.rds_password.result # результат генерации пароля
}

data "aws_ssm_parameter" "my_rds_password" {
  name       = "/prod/mysql"
  depends_on = [aws_ssm_parameter.rds_password]
}


resource "aws_db_instance" "rds_db" {
  identifier           = "prod-rds"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "prod"
  username             = "administrator"
  password             = data.aws_ssm_parameter.my_rds_password.value
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  apply_immediately    = true
}


output "rds_password" {
  sensitive = true
  value     = data.aws_ssm_parameter.my_rds_password.value
}

