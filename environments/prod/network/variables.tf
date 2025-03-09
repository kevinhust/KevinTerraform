variable "vpc_cidr" {
  type        = string
  description = "The CIDR block for the VPC"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "List of public subnet CIDR blocks"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "List of private subnet CIDR blocks"
}

variable "azs" {
  type        = list(string)
  description = "List of availability zones"
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
