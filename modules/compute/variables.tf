variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "fio"
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_id" {
  description = "Public subnet ID"
  type        = string
}

variable "frontend_repo_url" {
  description = "Frontend ECR repository URL"
  type        = string
}

variable "backend_repo_url" {
  description = "Backend ECR repository URL"
  type        = string
}

variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
}

variable "ami" {
  description = "EC2 AMI ID"
  type        = map(string)
  default = {
    ap-northeast-1 = "ami-0ed99df77a82560e6"  # Tokyo
    ap-northeast-2 = "ami-0c9c942bd7bf113a2"  # Seoul
  }
}