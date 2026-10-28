# Output Securuty group id
output "sg_id" {
    value = aws_security_group.my_group.id
}