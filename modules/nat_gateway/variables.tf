variable "public_subnet_id" {
  description = "ID of the public subnet"
  type        = string
}

variable "private_route_table_id" {
  description = "ID of the private route table"
  type        = string
}

variable "env" {
  description = "Environment name"
  type        = string
}

variable "tags" {
  description = "Tags for NAT Gateway resources"
  type        = map(string)
}

variable "prefix" {
  description = "Resource name prefix"
  type        = string
}
