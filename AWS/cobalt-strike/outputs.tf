output "private_ip" {
  value = aws_instance.cs.private_ip
}

output "public_ip" {
  value = aws_instance.cs.public_ip
}

output "teams-password" {
  value = var.cspw
}
