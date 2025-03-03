variable "vpc_id" {
  type = string
}

variable "route_table_id" {
  type = string
}

variable "env" {
  type = string
}

variable "tags" {
  type = map(string)
}