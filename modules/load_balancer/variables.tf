variable "vpc_id" {
  type        = string
  description = "The ID of the VPC"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for the Load Balancer"
}

variable "vm_ids" {
  type        = list(string)
  description = "List of VM IDs to attach to the Load Balancer"
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
