# Configure S3 backend for Terraform state storage
terraform {
  backend "s3" {
    bucket         = "kevinhust-p1-nonprod"
    key            = "non-prod/network/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks-nonprod"  # Optional: for state locking
  }
}