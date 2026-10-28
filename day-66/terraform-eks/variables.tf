# VARIABLES
# AWS Cluster region
variable "region" {
  description = "This holds default region where the EKS cluster will create"
  type        = string
}


# AWS Cluster name
variable "cluster_name" {
  description = "This holds defaul the EKS cluster name"
  type        = string
  default     = "terraweek-eks"
}


# AWS Cluster version
variable "cluster_version" {
  description = "This holds default EKS cluster version"
  type        = string
  default     = "1.31"
}


# AWS Cluster node instance type
variable "node_instance_type" {
  description = "This holds default EKS cluster node instance type"
  type        = string
  default     = "t3.micro"
}


# AWS Cluster node desired count
variable "node_desired_count" {
  description = "This holds default EKS cluster node count"
  type        = number
  default     = 2
}


# AWS VPC cidr
variable "vpc_cidr" {
  description = "This holds default VPC cidr"
  type        = string
  default     = "10.0.0.0/16"
}