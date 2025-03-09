# Availability Zones
azs = ["us-east-1a", "us-east-1b"]

# VPC CIDR block
vpc_cidr = "10.0.0.0/16"

# Subnet CIDR blocks
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]

# Environment name
env = "non-prod"

# Resource prefix
prefix = "kevin"

# Default tags
default_tags = {
  "Environment" = "non-prod"
  "Project"     = "terraform-demo"
  "Owner"       = "kevin"
} 