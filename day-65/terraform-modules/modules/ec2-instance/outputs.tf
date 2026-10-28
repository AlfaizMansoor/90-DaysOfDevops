# Outputs Instance id
output "instance_id" {
    value = aws_instance.new_server_instance.id
}


# Output Public ip
output "public_ip" {
    value = aws_instance.new_server_instance.public_ip
}


# Outputs Private ip
output "private_ip" {
    value = aws_instance.new_server_instance.private_ip
}