output "private_ip" {
  value =  aws_instance.evilginx.private_ip
}

output "public_ip" {
  value =  aws_instance.evilginx.public_ip
}
