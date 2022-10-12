provider "aws" {
  region = "eu-central-1"
}

resource "null_resource" "command1" {
  provisioner "local-exec" {
    command = "echo Terraform START:$(Date) >> log.txt "
  }
}

resource "null_resource" "command2" {
  provisioner "local-exec" {
    command = "ping www.google.com"
  }
  depends_on = [null_resource.command1]
}

resource "null_resource" "command3" {
  provisioner "local-exec" {
    interpreter = ["python", "-c"]        # можно указавать параметры запуска
    command     = "print('Hello world!')" # команда python
  }
  depends_on = [null_resource.command2] # зависимость от ранее запущенных ресурсов
}

resource "null_resource" "command4" {
  provisioner "local-exec" {
    command = "echo $NAME1 $NAME2 $NAME3 >> names.txt" # используем ресурсы environment
    environment = {                                    # присваиваем значения environment
      NAME1 = "Vasya"
      NAME2 = "Vania"
      NAME3 = "Kolya"
    }
  }
}

resource "aws_insatance" "server" {
  ami           = ""
  instance_type = "t3.micro"
  provisioner "local-exec" {
    command = "echo Hello from AWS Instance"
  }
}

resource "null_resource" "end" {
  provisioner "local-exec" {
    command = "echo Terraform END:$(Date) >> log.txt "
  }
  depends_on = [null_resource.command1, null_resource.command2, null_resource.command3, null_resource.command5, aws_insatance.server]
}
