# Terraform Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.7.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1" # Mumbai region mapping
}
