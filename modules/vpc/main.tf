resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags       = merge(var.tags, { Name = "${var.prefix}-${var.env}-vpc" })
  enable_dns_hostnames = true
  enable_dns_support   = true
}
