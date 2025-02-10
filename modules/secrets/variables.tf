variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "fio"
}

variable "db_master_username" {
  description = "Database master username"
  type        = string
  sensitive   = true
}

variable "db_master_password" {
  description = "Database master password" 
  type        = string
  sensitive   = true
}

variable "gandi_api_key" {
  description = "Gandi API Key"
  type        = string
  sensitive   = true
}