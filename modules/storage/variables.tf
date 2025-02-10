variable "bucket_name" {
  description = "Name of S3 bucket"
  type        = string
  default     = "fio-doc"
}

variable "enable_versioning" {
  description = "Enable versioning on bucket"
  type        = bool
  default     = true
}