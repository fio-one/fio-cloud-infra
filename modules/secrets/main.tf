# RDS Secret
resource "aws_secretsmanager_secret" "rds_credentials" {
  name = "fio_app/rds/credentials"
  force_overwrite_replica_secret = true
  recovery_window_in_days = 0

  tags = {
    Name = "fio_app-rds-credentials"
  }
}

resource "aws_secretsmanager_secret_version" "rds_credentials" {
  secret_id = aws_secretsmanager_secret.rds_credentials.id
  secret_string = jsonencode({
    username = var.db_master_username
    password = var.db_master_password
  })
}

# Gandi API Secret
resource "aws_secretsmanager_secret" "gandi_api" {
  name = "fio_app/gandi/api-key"
  recovery_window_in_days = 30
}

resource "aws_secretsmanager_secret_version" "gandi_api" {
  secret_id     = aws_secretsmanager_secret.gandi_api.id
  secret_string = var.gandi_api_key
}