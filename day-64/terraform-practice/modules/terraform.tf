terraform {
  backend "s3" {
    bucket         = "terraweek-state-alfaiz"
    key            = "dev/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    use_lockfile   = true
  }
}