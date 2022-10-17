provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "Server1" {
  ami           = "ami-05ff5eaef6149df49"
  instance_type = "t2.micro"
  tags = {
    Name  = "Server-1"
    Owner = "AV"
  }
}

# terraform apply -replace aws_instance.Server2, ресурс будет сразу пересоздан
resource "aws_instance" "Server2" {
  ami           = "ami-05ff5eaef6149df49"
  instance_type = "t2.micro"
  tags = {
    Name  = "Server-2"
    Owner = "AV"
  }
}

resource "aws_instance" "Server3" {
  ami           = "ami-05ff5eaef6149df49"
  instance_type = "t2.micro"
  tags = {
    Name  = "Server-3"
    Owner = "AV"
  }
  depends_on = [
    aws_instance.Server1
  ]
}
