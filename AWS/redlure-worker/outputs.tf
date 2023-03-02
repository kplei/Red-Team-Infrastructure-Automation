output "private_ip" {
  value = aws_instance.redlure-worker[*].private_ip
}

output "public_ip" {
  value = aws_instance.redlure-worker[*].public_ip
}
