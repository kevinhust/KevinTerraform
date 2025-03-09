variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "route_table_id" {
  description = "ID of the route table"
  type        = string
}

variable "env" {
  description = "Environment name"
  type        = string
}

variable "tags" {
  description = "Tags for Internet Gateway resources"
  type        = map(string)
}

variable "prefix" {
  description = "Resource name prefix"
  type        = string
}
