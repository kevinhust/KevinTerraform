variable "vpc_id" {
  type = string
}

variable "public_subnet_id" {
  type = string
}

variable "private_route_table_id" {
  type = string
}

variable "env" {
  type = string
}

variable "tags" {
  type = map(string)
}