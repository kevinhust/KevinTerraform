variable "instance_count" {
  default = 2
}

variable "instance_type" {
  default = "t2.medium"
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "tags" {
  type = map(string)
  default = {
    Environment = "prod"
    Project     = "kevinproject"
  }
}