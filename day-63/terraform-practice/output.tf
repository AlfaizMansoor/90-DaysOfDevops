# AWS vpc id 
output "vpc_id" {
  value = aws_vpc.main.id
}


# AWS subnet id
output "subnet_id" {
  value = aws_subnet.my_subnet.id
}


# AWS instance id
output "instance_id" {
  value = aws_instance.my_new_instance.id
}


# AWS Instance public IP
output "instance_public_ip" {
  value = aws_instance.my_new_instance.public_ip
}


# AWS Instance public DNS
output "instance_public_dns" {
  value = aws_instance.my_new_instance.public_dns
}


# AWS Security group ID
output "security_group_id" {
  value = aws_security_group.my_secure_group.id
}
