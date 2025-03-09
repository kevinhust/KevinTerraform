# Environment name
env = "prod"

# Resource prefix
prefix = "kevin"

# Default tags
default_tags = {
  "Environment" = "prod"
  "Project"     = "terraform-demo"
  "Owner"       = "kevin"
}

# VPC CIDR (needed for bastion access)
vpc_cidr = "10.1.0.0/16"

# Instance types per environment are defined in variables.tf with defaults 