# Security group for RDS
resource "aws_security_group" "rds_sg" {
  name        = "fio-app-rds-sg"  
  description = "Security group for RDS"
  vpc_id      = var.vpc_id

  ingress {
    description     = "MySQL from EC2"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.ec2_security_group_id]
  }
  
  tags = {
    Name = "fio-app-rds-sg"
  }
}

# DB subnet group
resource "aws_db_subnet_group" "main" {
  name       = "fio-app-db-subnet" 
  subnet_ids = var.subnet_ids

  tags = {
    Name = "fio-app-db-subnet-group"
  }
}

# RDS instance
resource "aws_db_instance" "main" {
  identifier        = "fio-app-mysql"  
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  storage_type      = "gp2"
  
  username = var.db_username
  password = var.db_password
  
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name
  
  skip_final_snapshot = true
  
  tags = {
    Name = "fio-app-rds" 
  }
}