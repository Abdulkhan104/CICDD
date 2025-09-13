# Security group
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg"             # simple name
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
  subnet_id     = data.aws_subnets.default_vpc.ids[0]

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]  # ✅ use ID here

  tags = {
    Name = "junnkins"
  }
}

output "ec2_public_ip" {
  description = "Public IP of EC2 instance"
  value       = aws_instance.web.public_ip
}
