# VPC identifier
variable "vpc_id" {
  type        = string
  description = "VPC identifier"
}

# Subnet IDs for Load Balancer
variable "subnet_ids" {
  type        = list(string)
  description = "Subnet identifiers"
}

# VM IDs for target group
variable "vm_ids" {
  type        = list(string)
  description = "VM instance identifiers"
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