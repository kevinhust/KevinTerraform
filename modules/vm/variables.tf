variable "instance_count" {
  type        = number
  description = "Number of VM instances to create"
}

variable "instance_type" {
  type        = string
  description = "The instance type for VMs"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for VMs"
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC"
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

variable "bastion_cidr" {
  type        = string
  description = "The CIDR block for SSH access (usually from Bastion)"
}

variable "key_name" {
  type        = string
  description = "The name of the key pair for SSH access"
}

variable "is_bastion" {
  type        = bool
  description = "Whether this instance is a Bastion host (true) or a regular VM (false)"
  default     = false
}