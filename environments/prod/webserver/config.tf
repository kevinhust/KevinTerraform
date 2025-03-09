terraform {
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
