variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "subnet_cidrs" {
  description = "List of subnet CIDR blocks"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}

variable "env" {
  description = "Environment name"
  type        = string
}

variable "tags" {
  description = "Tags for subnet resources"
  type        = map(string)
}

variable "prefix" {
  description = "Resource name prefix"
  type        = string
}
