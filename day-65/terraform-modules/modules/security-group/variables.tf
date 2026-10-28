# Variables

# AWS VPC id
variable "vpc_id" {
  description = "This holds defalut vpc id"
  type = string
}


# AWS Secure group
variable "sg_name" {
    description = "This hold default security group name"
    type = string
    default = "my-secured-group"
}


# AWS Ingress ports
variable "ingress_ports" {
    description = "This holds default ingress ports"
    type = list(number)
    default = [22, 80]
}


# AWS tags
variable "tags" {
    description = "This holds default tags"
    type = map(string)
    default = {}
}
