# AWS Security group
resource "aws_security_group" "main_secure_group" {
    vpc_id = var.vpc_id
    name = "${var.project_name}-${var.environment}"

    tags = {
      Name = var.project_name
      Environment = var.environment
    }

    # Ingress rule for some ports
    dynamic "ingress" {
      for_each = var.ingress_ports
      content {
        description = "Allowing inbound rules"
        from_port = ingress.value
        to_port = ingress.value
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    }

    # Egress outbound rule for all ports
    egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}