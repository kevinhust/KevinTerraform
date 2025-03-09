variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}

variable "env" {
  description = "Environment name"
  type        = string
}

variable "prefix" {
  description = "Resource name prefix"
  type        = string
}

variable "default_tags" {
  description = "Default tags for all resources"
  type        = map(string)
}
