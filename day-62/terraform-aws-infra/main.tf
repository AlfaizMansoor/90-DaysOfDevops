# AWS VPC
resource aws_vpc main {
	cidr_block = "10.0.0.0/16"
	tags = {
		Name = "TerraWeek-VPC"
	}
}

# AWS Subnet
resource aws_subnet my_subnet {
	cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  vpc_id = aws_vpc.main.id
	tags = {
		Name = "TerraWeek-Public-Subnet"
	}
}

# AWS Internet Gateway
resource aws_internet_gateway my_gateway {
	vpc_id = aws_vpc.main.id
}

# AWS Route Table
resource aws_route_table my_route_table {
	vpc_id = aws_vpc.main.id
	
	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.my_gateway.id
	}
}

# AWS Route Table Association
resource aws_route_table_association my_rt_association {
	subnet_id = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_route_table.id
}

# AWS Security Group
resource aws_security_group my_secure_group {
  name = "terra-secure-group"
  vpc_id = aws_vpc.main.id

  # Tag
  tags = {
    Name = "TerraWeek-Server"
  }
}

# Ingress rule for SSH on Port 22
resource aws_vpc_security_group_ingress_rule allow_ssh {
  security_group_id = aws_security_group.my_secure_group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# Ingress rule for HTTP on Port 80
resource aws_vpc_security_group_ingress_rule allow_port {
  security_group_id = aws_security_group.my_secure_group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

# Egress rule for all outbound traffic
resource aws_vpc_security_group_egress_rule allow_outbound {
  security_group_id = aws_security_group.my_secure_group.id
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

# AWS EC2 Instance
resource aws_instance my_new_instance {
  ami = "ami-04394a3a96907e9ec"
  instance_type = "t3.micro"
  subnet_id = aws_subnet.my_subnet.id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.my_secure_group.id]

  tags = {
    Name = "TerraWeek-Server"
  }

  lifecycle {
  create_before_destroy = true
  }
}

# AWS S3 Bucket
resource aws_s3_bucket new_bucket {
  bucket = "day-62-bucket-alfaiz"
  depends_on = [aws_instance.my_new_instance]
}
