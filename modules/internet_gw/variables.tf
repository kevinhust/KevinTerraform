# VPC identifier
variable "vpc_id" {
  type        = string
  description = "VPC identifier"
}

# Route table identifier
variable "route_table_id" {
  type        = string
  description = "Route table identifier"
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