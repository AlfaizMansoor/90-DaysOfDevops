variable "instances" {
  type = map(object({
    ami           = string
    os_family     = string
    user          = string
    instance_type = string
  }))

  default = {
    "contorl-node" = {
      ami           = "ami-07f3a2cfd03d8ee81"
      os_family     = "Ubuntu"
      user          = "ubuntu"
      instance_type = "t3.micro"
    }
    "app" = {
      ami           = "ami-09f02015912e773f7"
      os_family     = "Amazon"
      user          = "ec2-user"
      instance_type = "t3.small"
    }
    "web" = {
      ami           = "ami-0cc098d14c47f965b"
      os_family     = "Amazon-linux"
      user          = "ec2-user"
      instance_type = "t3.small"
    }
    "db" = {
      ami           = "ami-0cc098d14c47f965b"
      os_family     = "Amazon-linux"
      user          = "ec2-user"
      instance_type = "t3.small"
    }
  }
}