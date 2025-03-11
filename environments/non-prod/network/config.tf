terraform {
  backend "s3" {
    bucket         = "kevinhust-a1-nonprod"
    key            = "non-prod/networking/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks-nonprod"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  required_version = ">= 1.0.0"
}

# Configure AWS provider
provider "aws" {
  region = var.region
}

# Define region variable for flexibility
variable "region" {
  default = "us-east-1"
}
