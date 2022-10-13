output "network_detail" {
  value = data.terraform_remote_state.network
}

output "sg_id" {
  value = aws_security_group.webserver.id
}

output "webserver_public_ip" {
  value = aws_instance.webserver.public_ip
}
