variable "instance_count" {
  description = "Number of instances to create"
  type        = number
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "env" {
  description = "Environment name"
  type        = string
}

variable "tags" {
  description = "Tags for VM resources"
  type        = map(string)
}

variable "bastion_cidr" {
  description = "CIDR block for bastion access"
  type        = string
}

variable "prefix" {
  description = "Resource name prefix"
  type        = string
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
}

variable "is_bastion" {
  description = "Whether this is a bastion host"
  type        = bool
  default     = false
}