# VPC Variables
variable "vpc_cidr" { type = string }
variable "env" { type = string }
variable "tags" { type = map(string) }
variable "prefix" { type = string }

# Subnet Variables
variable "subnet_cidrs" { type = list(string) }
variable "public_subnet_cidrs" { type = list(string) }
variable "azs" { type = list(string) }

# Internet Gateway Variables
variable "route_table_id" { type = string }

# NAT Gateway Variables
variable "public_subnet_id" { type = string }
variable "private_route_table_id" { type = string }

# Virtual Machine Variables
variable "instance_count" { type = number }
variable "instance_type" { type = string }
variable "subnet_ids" { type = list(string) }
variable "bastion_cidr" { type = string }
variable "key_name" { type = string }

# Load Balancer Variables
variable "vm_ids" { type = list(string) }