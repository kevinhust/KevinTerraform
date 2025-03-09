variable "vpc_cidr" {
  type        = string
  description = "The CIDR block for the VPC"
}

variable "env" {
  type        = string
  description = "The environment (e.g., non-prod, prod)"
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to apply to resources"
}

variable "prefix" {
  type        = string
  description = "The prefix for resource names"
}
