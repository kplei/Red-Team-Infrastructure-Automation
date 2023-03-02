output "private_ip" {
  value = aws_instance.redir.private_ip
}

output "public_ip" {
  value = aws_instance.redir.public_ip
}
