# Availability Zones
azs = ["us-east-1a", "us-east-1b"]

# VPC CIDR block
vpc_cidr = "10.1.0.0/16"

# Subnet CIDR blocks
public_subnet_cidrs  = []  # 生产环境不需要公共子网
private_subnet_cidrs = ["10.1.3.0/24", "10.1.4.0/24"]

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