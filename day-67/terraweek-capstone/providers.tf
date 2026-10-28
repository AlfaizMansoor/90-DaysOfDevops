terraform {
  required_version = ">= 1.5.0" # Prevents execution on outdated CLI engines

  required_providers {
    aws = {
      source  = "hashicorp/aws" # Tells Terraform to fetch the official plugin
      version = "~> 5.0"        # Pins version to v5.x to prevent breaking upgrades
    }
  }
}

provider "aws" {
  region = "us-west-1"
}