variable "vpc_id" {
  type        = string
  description = "The ID of the VPC"
}

variable "subnet_cidrs" {
  type        = list(string)
  description = "List of subnet CIDR blocks"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "List of public subnet CIDR blocks"
}

variable "azs" {
  type        = list(string)
  description = "List of availability zones"
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
