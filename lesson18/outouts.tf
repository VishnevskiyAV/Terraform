output "aws_security_group" {
  value = aws_security_group.server_access.id
}

output "aws_instance" {
  value = aws_instance.my_server.id
}

output "aws_instance" {
  value = aws_instance.my_server.public_ip
}

