output "jumpbox_ip" {
  description = "The jumpbox ip for ssh access"
  value       = aws_instance.bastion_host.public_ip
}

output "web_server_ip" {
  description = "The web server's public ip"
  value       = aws_instance.web.public_ip
}

output "web_server_private_ip" {
  description = "the web server's private ip"
  value = aws_instance.web.private_ip
}

output "elasticsearch_private_ip" {
  description = "the elasticsearch node's private ip"
  value = aws_instance.elastic.private_ip
}
