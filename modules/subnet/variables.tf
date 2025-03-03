# VPC identifier
variable "vpc_id" {
  type        = string
  description = "VPC identifier"
}

# Subnet CIDR blocks
variable "subnet_cidrs" {
  type        = list(string)
  description = "Subnet CIDR blocks"
}

# Public subnet CIDR blocks
variable "public_subnet_cidrs" {
  type        = list(string)
  default     = []
  description = "Public subnet CIDR blocks"
}

# Availability zones
variable "azs" {
  type        = list(string)
  description = "Availability zones"
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