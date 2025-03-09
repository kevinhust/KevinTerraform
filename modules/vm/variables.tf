variable "prefix" {
  description = "Prefix for all resources"
  type        = string
}

variable "env" {
  description = "Environment (e.g., prod, non-prod)"
  type        = string
}

variable "instance_count" {
  description = "Number of instances to create"
  type        = number
  default     = 1
}

variable "instance_type" {
  description = "Instance type"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "is_bastion" {
  description = "Whether this is a bastion host"
  type        = bool
  default     = false
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
}

variable "bastion_sg" {
  description = "Security group ID of the bastion host (required for non-bastion instances)"
  type        = string
  default     = null
}