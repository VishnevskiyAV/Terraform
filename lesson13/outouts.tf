
output "websrver_instance_id" {
  value = aws_instance.my_webserver.id
  description = "This is id of instance" # можно добавлять description
}

output "websrver_public_ip" {
  value = aws_instance.my_webserver.public_ip
}

output "websrver_sg_id" {
  value = aws_security_group.web_access.id
}

output "websrver_sg_arn" {
  value = aws_security_group.web_access.arn
}