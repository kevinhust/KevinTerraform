# Availability Zones
azs = ["us-east-1a", "us-east-1b"]

# VPC CIDR block
vpc_cidr = "10.10.0.0/16"

# Subnet CIDR blocks (prod只有私有子网)
private_subnet_cidrs = ["10.10.1.0/24", "10.10.2.0/24"]
public_subnet_cidrs  = []  # prod环境不需要公有子网

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