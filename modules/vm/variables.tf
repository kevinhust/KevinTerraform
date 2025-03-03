# Number of instances to create
variable "instance_count" { type = number }

# Instance type
variable "instance_type" { type = string }

# Subnet IDs for instances
variable "subnet_ids" { type = list(string) }

# Deployment environment
variable "env" { type = string }

# Tags for resources
variable "tags" { type = map(string) }

# VPC identifier
variable "vpc_id" { type = string }

# CIDR block for Bastion host access
variable "bastion_cidr" { type = string, default = "10.0.0.0/32" }

# Prefix for resource naming
variable "prefix" { type = string, default = "kevinproject", description = "Name prefix" }

# SSH key pair name
variable "key_name" { type = string, description = "SSH key pair name" }