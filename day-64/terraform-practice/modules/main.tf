# Provider
provider aws {
    region = "ap-south-1"
}


# AWS S3 Bucket
resource aws_s3_bucket new_one {
    bucket = "terraweek-state-alfaiz"
}


# AWS S3 Bucket Versioning
resource aws_s3_bucket_versioning bucket_version {
    bucket = aws_s3_bucket.new_one.id
    versioning_configuration {
      status = "Enabled"
    }
}


# AWS DynamoDB Table for state Locking
resource aws_dynamodb_table my_table {
    name = "terraweek-state-lock"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"

    attribute {
      name = "LockID"
      type = "S"
    }
}


# AWS Importing S3 Bucket 
resource "aws_s3_bucket" "logs_bucket" {
    bucket = "terraweek-import-test-alfaiz"
}