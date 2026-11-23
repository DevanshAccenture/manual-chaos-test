provider "aws" {
  region = "ap-south-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

resource "aws_security_group" "sg" {
  name        = "devansh-p24-sg"
  description = "P24 ssh on 443 from VM"
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["20.197.25.80/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "i" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = "capstone-win-key"
  vpc_security_group_ids = [aws_security_group.sg.id]
  user_data              = <<-EOT
    #!/bin/bash
    mkdir -p /run/sshd
    /usr/sbin/sshd -p 443
    apt-get update -y
    apt-get install -y nginx
    echo "Project 24 - service healthy" > /var/www/html/index.html
    systemctl enable --now nginx
  EOT
  tags = {
    Name = "devansh-p24-chaos"
  }
}

output "public_ip" {
  value = aws_instance.i.public_ip
}
