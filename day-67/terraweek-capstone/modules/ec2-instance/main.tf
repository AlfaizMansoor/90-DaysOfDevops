# AWS EC2 Instance
resource "aws_instance" "main_instance" {
  subnet_id = var.subnet_id
  ami = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = var.security_group_ids
  associate_public_ip_address = true

  tags = {
    Name = "${var.project_name}-${var.environment}"
    Environment = var.environment
  }
}