# AWS Security group id
output "sg_id" {
  value = aws_security_group.main_secure_group.id
}