#IP data
data "http" "ssh_cidr" {
  url = "https://ipv4.icanhazip.com"
}
data "aws_ami" "ubuntu" {
  // Gets the latest ubuntu AMI ID
  most_recent = true

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

   filter {
    name   = "name"
    values = ["ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical's ID - creators of the Ubuntu AMI
}

#Creating the EC2 instance and Docker installation
resource "aws_instance" "jenkins_instance" {
  instance_type = var.instance_type
  ami = data.aws_ami.ubuntu.id
  key_name      = var.key_pair_name
  security_groups = [aws_security_group.jenkins_sg.name]

   user_data = <<-EOF
              #!/bin/bash
              sleep 20
              sudo apt-get update && sudo apt-get install -y apt curl gnupg
              sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
              curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
              sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
              sudo apt-get update
              sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
              sudo systemctl start docker
              sudo systemctl enable docker 

              # Expose Docker port in the security group
              aws ec2 authorize-security-group-ingress --group-id ${aws_security_group.jenkins_sg.id} --protocol tcp --port 2375 --cidr 0.0.0.0/0

              sudo docker pull ${var.jenkins_image}

              EOF      
}

#Inline commands via remote-exec: Starting the Jenkins container
resource "terraform_data" "inline_commands" {
  depends_on = [ aws_instance.jenkins_instance ]
    connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.key_pair)
    host        = aws_instance.jenkins_instance.public_dns
  }
  provisioner "remote-exec" {
    inline = [
      "sleep 120",
      "sudo docker run --user root -d --restart unless-stopped -v /var/run/docker.sock:/var/run/docker.sock -p 8080:8080 --name ${var.jenkins_container_name} -e JENKINS_ADMIN_ID=${var.jenkins_admin_id} -e JENKINS_ADMIN_PASSWORD=${var.jenkins_admin_password} -e JENKINS_IP_ADDRESS=${aws_instance.jenkins_instance.public_dns} ${var.jenkins_image}"
    ]
  }
}

#Security groups
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg"
  description = "Security group for Jenkins instance"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.ssh_cidr.response_body)}/32"]
  }

  // Egress rules (outbound)
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = -1
    cidr_blocks     = [var.cidr_block]
  }

  // Allow outbound access to ports 80 and 443 (HTTP and HTTPS)
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }
}