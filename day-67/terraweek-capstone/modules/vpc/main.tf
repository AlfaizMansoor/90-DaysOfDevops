# AWS VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = var.cidr

  tags = {
    Name = "${var.project_name}-${var.environment}"
    Environment = var.environment
  }
}


# AWS Public subnet
resource "aws_subnet" "main_subnet" {
  cidr_block = var.public_subnet_cidr
  vpc_id = aws_vpc.main_vpc.id
}


# AWS Internet gateway
resource "aws_internet_gateway" "main_gateway" {
  vpc_id = aws_vpc.main_vpc.id
}


# AWS Route Table
resource "aws_route_table" "main_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_gateway.id
  }
}


# AWS Route table association
resource "aws_route_table_association" "main_route_table_association" {
  subnet_id = aws_subnet.main_subnet.id
  route_table_id = aws_route_table.main_route_table.id
}