# AWS AMI id
variable "ami_id" {
  type = string
  description = "ami id of ec2 instance"
}


# AWS Instance type
variable "instance_type" {
  type = string
  description = "This holds instance type"
}


# AWS Subnet id
variable "subnet_id" {
  type = string
  description = "This holds subnet id"
}


# AWS Security group id
variable "security_group_ids" {
  type = list(string)
  default = []
  description = "This holds Security group id"
}


# AWS Environment
variable "environment" {
  type = string
  default = "dev"
  description = "Local Environment"
}


# AWS Project name
variable "project_name" {
  type = string
  default = "terraweek-capstone"
  description = "Project name"
}
