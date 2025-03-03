# First VPC identifier
variable "vpc1_id" {
  type        = string
  description = "First VPC identifier"
}

# Second VPC identifier
variable "vpc2_id" {
  type        = string
  description = "Second VPC identifier"
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