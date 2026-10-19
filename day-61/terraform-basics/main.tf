# Terraform block
terraform {
	required_version = ">= 1.5.0"

	required_providers {
		aws = {
			source = "hashicorp/aws"
			version = "~> 5.0"

		}
	}
}

# AWS Provider
provider aws {
	region = "ap-south-1"
}

# AWS S3 Bucket
resource aws_s3_bucket day_61_bucket {
	bucket = "day-61-bucket-alfaiz"

}

# TASK-4 :- AWS EC2 Instance
resource aws_instance new_instance {
  ami = "ami-01a00762f46d584a1"
  instance_type = "t3.micro"

  tags = {
    Name = "TerraWeek-Modified"
  }
}
