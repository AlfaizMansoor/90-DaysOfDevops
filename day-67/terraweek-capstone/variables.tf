# AWS Project name
variable "project_name" {
  type    = string
  default = "terraweek"
}


# AWS Vpc cidr
variable "vpc_cidr" {
  type = string
}


# AWS Subnet cidr
variable "subnet_cidr" {
  type = string
}


# AWS Instance type
variable "instance_type" {
  type = string
}


# AWS Ingress ports
variable "ingress_ports" {
  type    = list(number)
  default = [22, 80]
}