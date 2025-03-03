# VPC identifier
variable "vpc_id" {
  type        = string
  description = "VPC identifier"
}

# Public subnet identifier
variable "public_subnet_id" {
  type        = string
  description = "Public subnet identifier"
}

# Private route table identifier
variable "private_route_table_id" {
  type        = string
  description = "Private route table identifier"
}

# Deployment environment
variable "env" {
  type        = string
  description = "Deployment Environment"
}

# Tags for resources
variable "tags" {
  type        = map(string)
  description = "Default tags to be applied to all AWS resources"
}

# Prefix for resource naming
variable "prefix" {
  type        = string
  default     = "kevinproject"
  description = "Name prefix"
}