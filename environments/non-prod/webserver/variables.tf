# VPC CIDR is needed for bastion access
variable "vpc_cidr" {
  description = "CIDR block of the VPC"
  type        = string
}

# Instance type mapping
variable "instance_type" {
  description = "EC2 instance type mapping"
  type        = map(string)
  default = {
    "non-prod" = "t2.micro"
    "prod"     = "t3.medium"
  }
}

# Environment name
variable "env" {
  description = "Environment name"
  type        = string
}

# Resource prefix
variable "prefix" {
  description = "Resource name prefix"
  type        = string
}

# Default tags
variable "default_tags" {
  description = "Default tags for all resources"
  type        = map(string)
}
