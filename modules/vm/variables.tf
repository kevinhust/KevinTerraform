variable "instance_count" {
  type = number
}

variable "instance_type" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "env" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "vpc_id" {
  type = string
}

variable "bastion_cidr" {
  type    = string
  default = "10.0.0.0/32"
}