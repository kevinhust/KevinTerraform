variable "public_subnet_id" {
  type        = string
  description = "The ID of the public subnet"
}

variable "private_route_table_id" {
  type        = string
  description = "The ID of the private route table"
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
