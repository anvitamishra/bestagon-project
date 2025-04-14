#################################
# Provider Configuration
#################################
provider "aws" {
  region = "eu-central-1"
}

#################################
# Security Group
#################################
resource "aws_security_group" "bestagon_sg" {
  name        = "bestagon-sg"
  description = "Allow HTTP access"

  ingress {
    description      = "HTTP from anyone"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    description      = "All traffic out"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

#################################
# EC2 Instance
#################################
resource "aws_instance" "bestagon_server" {
  ami                    = "ami-0c02fb55956c7d316"  # Amazon Linux 2 in eu-central-1
  instance_type          = "t2.micro"

  key_name               = var.key_name
  security_groups        = [aws_security_group.bestagon_sg.name]

  # user_data runs on first boot
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install docker -y
              service docker start
              # Pull and run your Node.js Docker image
              docker run -d -p 80:3000 ${var.image_url}
              EOF

  tags = {
    Name = "bestagon-server"
  }
}
