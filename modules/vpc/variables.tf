# VPC CIDR block
variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
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