variable "vpc_id" {
  type        = string
  description = "The ID of the VPC"
}

variable "route_table_id" {
  type        = string
  description = "The ID of the route table"
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
