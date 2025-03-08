# VPC CIDR block
variable "vpc_cidr" {
  default     = "10.1.0.0/16"
  type        = string
  description = "VPC CIDR block"
}

# Public subnet CIDR blocks
variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.1.1.0/24", "10.1.2.0/24"]
  description = "Public subnet CIDR blocks"
}

# Private subnet CIDR blocks
variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.1.3.0/24", "10.1.4.0/24"]
  description = "Private subnet CIDR blocks"
}

# Availability zones
variable "azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
  description = "Availability zones"
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
  default     = "prod"
  type        = string
  description = "Deployment Environment"
}