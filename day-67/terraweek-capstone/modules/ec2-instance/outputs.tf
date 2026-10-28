# AWS Instance id
output "instance_id" {
  value = aws_instance.main_instance.id
}


# AWS Public ip
output "public_ip" {
  value = aws_instance.main_instance.public_ip
}