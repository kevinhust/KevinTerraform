variable "prefix" {
  description = "资源名称前缀"
  type        = string
}

variable "env_requester" {
  description = "请求方VPC的环境名称"
  type        = string
}

variable "env_accepter" {
  description = "接受方VPC的环境名称"
  type        = string
}

variable "requester_vpc_id" {
  description = "请求方VPC ID"
  type        = string
}

variable "accepter_vpc_id" {
  description = "接受方VPC ID"
  type        = string
}

variable "requester_vpc_cidr" {
  description = "请求方VPC CIDR"
  type        = string
}

variable "accepter_vpc_cidr" {
  description = "接受方VPC CIDR"
  type        = string
}

variable "requester_public_route_table_id" {
  description = "请求方公共子网路由表ID"
  type        = string
}

variable "requester_private_route_table_id" {
  description = "请求方私有子网路由表ID"
  type        = string
}

variable "accepter_public_route_table_id" {
  description = "接受方公共子网路由表ID"
  type        = string
}

variable "accepter_private_route_table_id" {
  description = "接受方私有子网路由表ID"
  type        = string
}

variable "tags" {
  description = "资源标签"
  type        = map(string)
  default     = {}
} 