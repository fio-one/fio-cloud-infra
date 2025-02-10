# Security Group
resource "aws_security_group" "ec2_sg" {
  name        = "fio-app-ec2-sg"
  description = "Security group for EC2"
  vpc_id      = var.vpc_id

  # HTTP 
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Node.js App
  ingress {
    description = "Node.js App"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "fio-app-ec2-sg"
  }
}

# EC2 Instance
resource "aws_instance" "app" {
  ami           = "ami-0ed99df77a82560e6"
  instance_type = "t2.large"
  subnet_id     = var.public_subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  tags = {
    Name = "Fio-App-Instance"
  }

  user_data = templatefile("${path.module}/templates/user_data.sh", {
    region          = var.region
    frontend_repo   = var.frontend_repo_url
    backend_repo    = var.backend_repo_url
    bucket_name     = var.bucket_name
  })
}