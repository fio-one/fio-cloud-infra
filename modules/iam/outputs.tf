output "developer_password" {
  value     = aws_iam_user_login_profile.developer.password
  sensitive = true
}