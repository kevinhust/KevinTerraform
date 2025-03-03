# Instance type for different environments
variable "instance_type" {
  default     = {
    "non-prod" = "t2.micro"
    "prod"     = "t2.medium"
  }
  type        = map(string)
  description = "Type of the instance"
}

# Default tags for resources
variable "default_tags" {
  default = {
    "Owner" = "acs730"
    "App"   = "Web"
  }
  type        = map(any)
  description = "Default tags to be applied to all AWS resources"
}

# Prefix for resource naming
variable "prefix" {
  default     = "kevinproject"
  type        = string
  description = "Name prefix"
}

# Deployment environment
variable "env" {
  default     = "non-prod"
  type        = string
  description = "Deployment Environment"
}

# VPC identifier
variable "vpc_id" {
  type        = string
  description = "VPC identifier"
}

# Public subnet identifiers
variable "public_subnet_ids" {
  type        = list(string)
  description = "Public subnet identifiers"
}

# Private subnet identifiers
variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet identifiers"
}

# VPC CIDR block
variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
}