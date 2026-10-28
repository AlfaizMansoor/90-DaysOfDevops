# AWS VPC id
variable "vpc_id" {
  type = string
  description = "This holds vpc id"
}


# AWS ingress ports
variable "ingress_ports" {
  type = list(number)
  default = [ 22, 80, 443 ]
  description = "This holds ingress ports"
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