# Local Block
locals {
  name_prefix = "${var.project_name}-${var.environment}"
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}


# AWS Data AMI Block
data "aws_ami" "amazon_linux" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "block-device-mapping.volume-type"
    values = ["gp2"]
  }
}

# AWS Data Availability Zone
data "aws_availability_zones" "available" {
  state = "available"
}


# AWS Provider Block
provider "aws" {
  region = var.region
}


# AWS VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${local.name_prefix}-vpc"
  }
}


# AWS Subnet
resource "aws_subnet" "my_subnet" {
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.main.id
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${local.name_prefix}-subnet"
  }
}


# AWS Internet Gateway
resource "aws_internet_gateway" "my_gateway" {
  vpc_id = aws_vpc.main.id
}


# AWS Route Table
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_gateway.id
  }
}


# AWS Route Table Association
resource "aws_route_table_association" "my_rt_association" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_route_table.id
}


# AWS Security Group
resource "aws_security_group" "my_secure_group" {
  name   = "${var.project_name}-${var.environment}-secure-group"
  vpc_id = aws_vpc.main.id


  # Ingress rule for all port 22, 80, 443
  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  # AWS Tags for inbound security rules
  tags = merge(
    {
      Name = "${var.project_name}-secure-group"
    },
    var.extra_tags
  )
}


# Egress rule for all outbound traffic
resource "aws_vpc_security_group_egress_rule" "allow_outbound" {
  security_group_id = aws_security_group.my_secure_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}


# AWS EC2 Instance
resource "aws_instance" "my_new_instance" {
  ami = data.aws_ami.amazon_linux.id

  # Conditional expression from task-6
  instance_type = var.environment == "prod" ? "t3.small" : "t3.micro"

  subnet_id                   = aws_subnet.my_subnet.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.my_secure_group.id]

  tags = merge(local.common_tags,
    {
      Name = "${local.name_prefix}-server"
    },
    var.extra_tags
  )

  lifecycle {
    create_before_destroy = true
  }
}


# AWS S3 Bucket
resource "aws_s3_bucket" "new_bucket" {
  bucket     = "day-62-bucket-alfaiz"
  depends_on = [aws_instance.my_new_instance]
}

