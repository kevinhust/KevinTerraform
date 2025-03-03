# Instance type
variable "instance_type" {
  default     = {
    "non-prod" = "t2.micro"
    "prod"     = "t2.medium"
  }
  description = "Type of the instance"
  type        = map(string)
}

# Default tags
variable "default_tags" {
  default = {
    "Owner" = "acs730"
    "App"   = "Web"
  }
  type        = map(any)
  description = "Default tags to be applied to all AWS resources"
}

# Prefix to identify resources
variable "prefix" {
  default     = "kevinproject"
  type        = string
  description = "Name prefix"
}

# Environment
variable "env" {
  default     = "prod"
  type        = string
  description = "Deployment Environment"
}

variable "vpc_id" {
  type        = string
  description = "VPC identifier"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet identifiers"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
}