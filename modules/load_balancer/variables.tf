variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the load balancer"
  type        = list(string)
}

variable "vm_ids" {
  description = "List of VM instance IDs"
  type        = list(string)
}

variable "env" {
  description = "Environment name"
  type        = string
}

variable "tags" {
  description = "Tags for Load Balancer resources"
  type        = map(string)
}

variable "prefix" {
  description = "Resource name prefix"
  type        = string
}
