terraform {
  backend "s3" {
    bucket         = "kevinhust-p1-prod"
    key            = "prod/network/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks-prod"
  }
}