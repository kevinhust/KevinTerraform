variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "azs" {
  type    = list(string)
  default = ["us-easr-1a", "us-east-1b"]
}

variable "tags" {
  type = map(string)
  default = {
    Environment = "non-prod"
    Project     = "kevinproject"
  }
}