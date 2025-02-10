output "bucket_name" {
  description = "Name of S3 bucket"
  value       = var.bucket_name
}

output "bucket_arn" {
  description = "ARN of S3 bucket"
  value       = "arn:aws:s3:::${var.bucket_name}"
}