# AWS cidr variable 
variable "cidr" {
  type = string
  default = "0.0.0.0/0"
  description = "Cidr value"
}


# AWS public subnet cidr
variable "public_subnet_cidr" {
  type = string
  default = "10.0.0.0/24"
  description = "public subnet Cidr value"
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