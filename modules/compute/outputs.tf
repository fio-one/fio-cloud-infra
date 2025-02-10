output "instance_id" {
  description = "ID of EC2 instance"
  value       = aws_instance.app.id
}

output "public_ip" {
  description = "Public IP of EC2 instance"
  value       = aws_instance.app.public_ip
}

output "security_group_id" {
  description = "EC2 security group ID"
  value       = aws_security_group.ec2_sg.id
}

output "ec2_role_id" {
  description = "EC2 IAM role ID"
  value       = aws_iam_role.ec2_role.id
}

output "ec2_role_name" {
  description = "EC2 IAM role name"
  value       = aws_iam_role.ec2_role.name
}