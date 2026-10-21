# AWS Region
variable "region" {
  type        = string
  description = "The target AWS region for deployment infrastructure"
  default     = "ap-south-1"
}

# AWS vpc cidr
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

# AWS subnet cidr
variable "subnet_cidr" {
  type    = string
  default = "10.0.0.0/24"
}

# AWS Instance type
variable "instance_type" {
  type    = string
  default = "t3.micro"
}

# AWS Project name
variable "project_name" {
  type = string # User should provide project name by his own 
}

# AWS Enviroment
variable "environment" {
  type    = string
  default = "dev"
}

# AWS Allowed ports
variable "allowed_ports" {
  type    = list(number)
  default = [22, 80, 443]
}

# AWS Tags
variable "extra_tags" {
  type    = map(string)
  default = {}
}
