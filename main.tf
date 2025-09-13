terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-3"  
}

# Get the default VPC
data "aws_vpc" "default" {
  default = true
}

# Get the default subnet in that VPC
data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

# Security group to allow SSH (22) and HTTP (80)
resource "aws_security_group" "ec2_sg" {
  name        = "aws_security_group.ec2_sg.id"
  description = "Allow SSH and HTTP"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 instance
resource "aws_instance" "web" {
  ami           = "ami-0fa00cdbbe31fbb37" 
  instance_type = "t2.medium"
  subnet_id     = data.aws_subnet_ids.default.ids[0]
  security_groups = [aws_security_group.ec2_sg.name]

  tags = {
    Name = "junnkins"
  }
}

output "ec2_public_ip" {
  description = "Public IP of EC2 instance"
  value       = aws_instance.web.public_ip
}
