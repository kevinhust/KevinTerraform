variable "prefix" {
  description = "Prefix for all resources"
  type        = string
}

variable "env" {
  description = "Environment (e.g., prod, non-prod)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the load balancer will be created"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the load balancer"
  type        = list(string)
}

variable "vm_ids" {
  description = "List of VM instance IDs to attach to the target group"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
