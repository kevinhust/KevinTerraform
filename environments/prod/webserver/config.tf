terraform {
  backend "s3" {
    bucket         = "kevinhust-p1-prod"
    key            = "prod/webserver/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks-prod"
  }
}