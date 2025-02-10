output "rds_secret_arn" {
  description = "ARN of RDS credentials secret"
  value       = aws_secretsmanager_secret.rds_credentials.arn
}

output "gandi_api_secret_arn" {
  description = "ARN of Gandi API key secret"
  value       = aws_secretsmanager_secret.gandi_api.arn
}