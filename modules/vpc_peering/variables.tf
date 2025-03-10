variable "prefix" {
  description = "Resource name prefix"
  type        = string
}

variable "env_requester" {
  description = "Environment name of the requester VPC"
  type        = string
}

variable "env_accepter" {
  description = "Environment name of the accepter VPC"
  type        = string
}

variable "requester_vpc_id" {
  description = "Requester VPC ID"
  type        = string
}

variable "accepter_vpc_id" {
  description = "Accepter VPC ID"
  type        = string
}

variable "requester_vpc_cidr" {
  description = "Requester VPC CIDR block"
  type        = string
}

variable "accepter_vpc_cidr" {
  description = "Accepter VPC CIDR block"
  type        = string
}

variable "requester_public_route_table_id" {
  description = "Public route table ID of the requester VPC"
  type        = string
  default     = null
}

variable "requester_private_route_table_id" {
  description = "Private route table ID of the requester VPC"
  type        = string
  default     = null
}

variable "accepter_public_route_table_id" {
  description = "Public route table ID of the accepter VPC"
  type        = string
  default     = null
}

variable "accepter_private_route_table_id" {
  description = "Private route table ID of the accepter VPC"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
} 