resource "aws_instance" "redir" {
  ami = var.ami
  # count                  = 3
  instance_type          = "t2.small"
  key_name               = var.key_name
  vpc_security_group_ids = ["<sg-2>", "<sg-2>", "<sg-3>"]
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
      # redirector
      ## nginx
      "sudo apt install nginx -y",
      "sudo apt install nginx nginx-extras -y",
      ## generate cert
      "sudo openssl req -x509 -nodes -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt -subj \"/C=US/ST=Denial/L=Springfield/O=Dis/CN=${var.domain}\"",
      ## malleable c2 profiles
      "sudo mkdir /opt/redirector/",
      "cd /opt/redirector/",
      "sudo apt install git -y",
      "sudo git clone https://github.com/threatexpress/malleable-c2.git",
      "sudo git clone https://github.com/rsmudge/Malleable-C2-Profiles.git",
      ## generate nginx config
      "sudo git clone https://github.com/threatexpress/cs2modrewrite.git",
      "sudo python3 ./cs2modrewrite/cs2nginx.py -i ${var.malleable-c2-profile} -c http://${aws_instance.redir.public_ip} -r https://google.com -H ${var.domain} > ~/nginx.conf",
      ## modify nginx config
      "sudo sed -i 's/set $C2_SERVER http:\\/\\/${aws_instance.redir.public_ip};/set $C2_SERVER https:\\/\\/$host;/' ~/nginx.conf",
      "sudo sed -i 's/#listen 443 ssl;/listen 443 ssl;/' ~/nginx.conf",
      "sudo sed -i 's/#listen \\[::\\]:443 ssl;/listen \\[::\\]:443 ssl;/' ~/nginx.conf",
      "sudo sed -i 's/#ssl on;/ssl on;/' ~/nginx.conf",
      "sudo sed -i 's/#ssl_certificate \\/etc\\/letsencrypt\\/live\\/<DOMAIN_NAME>\\/fullchain.pem; # managed by Certbot/ssl_certificate \\/etc\\/ssl\\/certs\\/nginx-selfsigned.crt;/' ~/nginx.conf",
      "sudo sed -i 's/#ssl_certificate_key \\/etc\\/letsencrypt\\/live\\/<DOMAIN_NAME>\\/privkey.pem; # managed by Certbot/ssl_certificate_key \\/etc\\/ssl\\/private\\/nginx-selfsigned.key;/' ~/nginx.conf",
      "sudo sed -i 's/#ssl_session_cache shared:le_nginx_SSL:1m; # managed by Certbot/ssl_session_cache shared:le_nginx_SSL:1m; # managed by Certbot/' ~/nginx.conf",
      "sudo sed -i 's/#ssl_session_timeout 1440m; # managed by Certbot/ssl_session_timeout 1440m; # managed by Certbot/' ~/nginx.conf",
      "sudo sed -i 's/#ssl_protocols TLSv1 TLSv1.1 TLSv1.2; # managed by Certbot/ssl_protocols TLSv1 TLSv1.1 TLSv1.2; # managed by Certbot/' ~/nginx.conf",
      "sudo sed -i 's/#ssl_prefer_server_ciphers on; # managed by Certbot/ssl_prefer_server_ciphers on; # managed by Certbot/' ~/nginx.conf",
      "sudo sed -i 's/# proxy_pass_header Server;/proxy_pass_header Server;\\n            proxy_ssl_verify    off;/' ~/nginx.conf",
      ## replace nginx config and restart
      "sudo cp ~/nginx.conf /etc/nginx/nginx.conf",
      "sudo systemctl reload nginx",
    ]
  }
}
