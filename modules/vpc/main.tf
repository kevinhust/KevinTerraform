resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags       = merge(var.tags, { Name = "\${var.prefix}-\${var.env}-vpc" })
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}
