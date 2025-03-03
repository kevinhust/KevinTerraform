terraform {
  backend "s3" {
    bucket         = "kevinhust-p1-nonprod"
    key            = "non-prod/webserver/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks-nonprod"
  }
}