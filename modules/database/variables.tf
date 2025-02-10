variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "fio"
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where database will be created"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for database"
  type        = list(string)
}

variable "db_username" {
  description = "Database master username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}

variable "ec2_security_group_id" {
  description = "Security group ID of EC2 instances"
  type        = string
}