# Dynamically queries AWS for the latest official Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-202*-x86_64"] # Matches the standard x86 64-bit production images
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}



# AWS module vpc
module "vpc" {
  source             = "./modules/vpc"
  cidr               = var.vpc_cidr
  public_subnet_cidr = var.subnet_cidr
  environment        = local.environment
  project_name       = var.project_name
}


# AWS module security group
module "security_group" {
  source        = "./modules/security-group"
  environment   = local.environment
  vpc_id        = module.vpc.vpc_id
  ingress_ports = var.ingress_ports
  project_name  = var.project_name
}


# AWS module EC2 Instance
module "ec2_instance" {
  source             = "./modules/ec2-instance"
  ami_id             = data.aws_ami.amazon_linux.id
  instance_type      = var.instance_type
  subnet_id          = module.vpc.subnet_id
  security_group_ids = [module.security_group.sg_id]
  environment        = local.environment
  project_name       = var.project_name
}