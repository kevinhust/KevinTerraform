variable "vpc_cidr" {
  default = "10.1.0.0/16"
}

variable "subnet_cidrs" {
  type    = list(string)
  default = ["10.1.1.0/24", "10.1.2.0/24"]
}

variable "azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]  # 更新为 us-east-1 的可用区
}

variable "tags" {
  type = map(string)
  default = {
    Environment = "prod"
    Project     = "kevinproject"
  }
}