
output "webserver_instance_id" {
  value = aws_instance.web_server.id
  description = "This is id of instance" # можно добавлять description
}

output "web_server_public_ip" {
  value = aws_instance.web_server.public_ip
}

output "app_server_public_ip" {
  value = aws_instance.app_server.public_ip
}

output "db_server_public_ip" {
  value = aws_instance.db_server.public_ip
}

output "webserver_sg_id" {
  value = aws_security_group.web_access.id
}

output "webserver_sg_arn" {
  value = aws_security_group.web_access.arn
}