variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "fio"
}

variable "environment" {
  description = "Environment name for resource naming"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["a", "c"]  # Matches current setup with AZs a and c
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_1_cidr" {
  description = "CIDR block for first private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_2_cidr" {
  description = "CIDR block for second private subnet"
  type        = string
  default     = "10.0.3.0/24"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}