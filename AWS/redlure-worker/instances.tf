resource "aws_instance" "redlure-worker" {
  ami = var.ami
  count                  = var.instance-count
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
      # install redlure worker
      "sudo apt update",
      "sudo apt install git -y",
      "cd /opt/",
      "sudo git clone https://github.com/kplei/redlure-worker.git",
      "cd ./redlure-worker/",
      "sudo ./install.sh",
      # modify redlure config
      "sudo sed -i \"s/API_KEY = '' /API_KEY = '<api key>'/\" ./config.py",
      "sudo sed -i \"s/SERVER_IP = ''/SERVER_IP = '${var.console-ip}'/\" ./config.py",
      # chronjob to start work on reboot
      "echo '@reboot root cd /opt/redlure-worker/; /usr/local/bin/pipenv run ./redlure-worker.py' >> /tmp/worker-start",
      "sudo mv /tmp/worker-start /etc/cron.d/worker-start",
      "sudo chown root:root /etc/cron.d/worker-start",
      "sudo shutdown -r"
    ]
  }
}
