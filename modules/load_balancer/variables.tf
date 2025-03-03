variable "vpc_id" {
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