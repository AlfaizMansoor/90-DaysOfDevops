# VARIABLES

# AWS AMI id
variable "ami_id" {
    description = "This holds default AMI id"
    type = string
    default = "ami-0a940816f3c484aa0"
}


# AWS Instance type
variable "instance_type" {
    description = "This holds default value type of instance"
    type = string
    default = "t3.micro"
}


# AWS Subnet id
variable "subnet_id" {
    description = "This holds default subnet id"
    type = string
    default = "10.0.0.0/16"
}


# AWS Security group id
variable "security_group_ids" {
    description = "This holds defcault security group id's"
    type = list(string)
    default = []
}


# AWS Instance name
variable "instance_name" {
    description = "This holds default instance name"
    type = string
    default = "new-server"
}


# AWS Tags
variable "tags" {
    description = "This holds deafult tags"
    type = map(string)
    default = {}
}