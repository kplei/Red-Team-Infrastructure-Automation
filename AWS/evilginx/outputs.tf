output "private_ip" {
  value =  aws_instance.gen.private_ip
}

output "public_ip" {
  value =  aws_instance.gen.public_ip
}
