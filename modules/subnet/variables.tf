variable "vpc_id" {
  type = string
}

variable "subnet_cidrs" {
  type = list(string)
}

variable "azs" {
  type = list(string)
}

variable "env" {
  type = string
}

variable "tags" {
  type = map(string)
}