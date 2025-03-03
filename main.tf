terraform {
  backend "s3" {}
}

# variables.tf
variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-1"
}

variable "bucket_name" {
  description = "S3 bucket name for application"
  type        = string
}

# Provider configuration
provider "aws" {
  region = var.region
}

# Add ECR policy to EC2 role
resource "aws_iam_role_policy" "ecr_policy" {
  name = "ecr-policy"
  role = module.compute.ec2_role_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
        Resource = "*"
      }
    ]
  })
}

data "aws_caller_identity" "current" {}

output "developer_password" {
  value     = module.iam.developer_password
  sensitive = true
}

output "ec2_public_ip" {
  value = module.compute.public_ip
  description = "Public IP of EC2 instance"
}

# Add IAM Password Policy
resource "aws_iam_account_password_policy" "strict" {
  minimum_password_length        = 8
  require_lowercase_characters   = true
  require_uppercase_characters   = true
  require_numbers               = true
  require_symbols               = true
  allow_users_to_change_password = true
}

# Output the RDS endpoint
output "rds_endpoint" {
  value = module.database.rds_endpoint
}

# Variables remain the same
variable "db_master_username" {
  description = "Master username for RDS"
  type        = string
  default     = "fable_roy"
}

variable "db_master_password" {
  description = "Master password for RDS"
  type        = string
  sensitive   = true
}

variable "gandi_api_key" {
  description = "Gandi API Key"
  type        = string
  sensitive   = true
}

# EC2 Secrets Policy
resource "aws_iam_policy" "ec2_secrets_policy" {
  name = "${var.environment}-ec2-secrets-policy"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = [
          module.secrets.rds_secret_arn,    
          module.secrets.gandi_api_secret_arn
        ]
      }
    ]
  })
}

# Attach to EC2 role
resource "aws_iam_role_policy_attachment" "ec2_secrets_policy_attachment" {
  role       = module.compute.ec2_role_name
  policy_arn = aws_iam_policy.ec2_secrets_policy.arn
}

module "iam" {
  source = "./modules/iam"
  region = var.region
  environment = var.environment
}

module "networking" {
  source = "./modules/networking"

  project_name = "fio"
  environment  = var.environment
  region       = var.region
}

module "database" {
  source = "./modules/database"

  project_name = "fio"
  environment  = var.environment
  vpc_id       = module.networking.vpc_id
  subnet_ids   = module.networking.private_subnet_ids
  
  db_username = var.db_master_username
  db_password = var.db_master_password

  ec2_security_group_id = module.compute.security_group_id
}

module "container" {
  source = "./modules/container"

  project_name = "fio"
  environment  = var.environment
}

module "storage" {
  source = "./modules/storage"

  bucket_name = var.bucket_name
  enable_versioning = true
  region = var.region
}

module "secrets" {
  source = "./modules/secrets"
  project_name = "fio"
  environment = var.environment
  region = var.region
  db_master_username = var.db_master_username
  db_master_password = var.db_master_password
  gandi_api_key = var.gandi_api_key
}

module "compute" {
  source = "./modules/compute"

  project_name      = "fio"
  environment       = var.environment
  region           = var.region
  vpc_id           = module.networking.vpc_id
  public_subnet_id = module.networking.public_subnet_id
  frontend_repo_url = module.container.frontend_repository_url
  backend_repo_url  = module.container.backend_repository_url
  bucket_name       = module.storage.bucket_name
}
