variable "vpc_id" {
  type        = string
  description = "The ID of the VPC"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs"
}

variable "vpc_cidr" {
  type        = string
  description = "The CIDR block for the VPC"
}

variable "instance_type" {
  type        = map(string)
  description = "Map of instance types per environment"
  default     = {
    "non-prod" = "t2.micro"
    "prod"     = "t3.medium"
  }
}

variable "env" {
  type        = string
  description = "The environment (e.g., non-prod, prod)"
  default     = "prod"
}

variable "default_tags" {
  type        = map(string)
  description = "A map of default tags to apply to resources"
}

variable "prefix" {
  type        = string
  description = "The prefix for resource names"
}
