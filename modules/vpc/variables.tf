variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "env" {
  description = "Environment name"
  type        = string
}

variable "tags" {
  description = "Tags for VPC resources"
  type        = map(string)
}

variable "prefix" {
  description = "Resource name prefix"
  type        = string
}
