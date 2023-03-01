resource "aws_instance" "cs" {
  #  name                   = var.name
  ami = var.ami
  # count                  = 3
  instance_type          = "t2.small"
  key_name               = var.key_name
  vpc_security_group_ids = ["<sg-1>", "<sg-2>"]
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
      "sudo apt update",
      "sudo apt install openjdk-11-jdk -y",
      "cd /opt",
      "sudo wget 'http://<private-webserver>/cobaltstrike-dist.tgz' -O ./cobaltstrike-dist.tgz",
      "sudo tar zxvf cobaltstrike-dist.tgz",
      "cd ./cobaltstrike",
      "yes <cs-license> | sudo ./update",
      "sudo apt install git -y",
      "sudo git clone https://github.com/Tw1sm/HTTPS-MalleableC2-Config",
      "sudo git clone https://github.com/killswitch-GUI/CobaltStrike-ToolKit.git",
      "sudo mkdir maleable-c2-profiles",
      "cd maleable-c2-profiles",
      "sudo git clone https://github.com/threatexpress/malleable-c2.git",
      "sudo git clone https://github.com/rsmudge/Malleable-C2-Profiles.git",
      "echo \"@reboot root cd /opt/cobaltstrike/; ./teamserver ${aws_instance.cs.public_ip} ${var.cspw} ${var.malleable-c2-profile}\" >> /tmp/cs-start",
      "sudo mv /tmp/cs-start /etc/cron.d/cs-start",
      "sudo chown root:root /etc/cron.d/cs-start",
      "sudo shutdown -r"
    ]
  }
}
