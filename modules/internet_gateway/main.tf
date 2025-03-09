resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id
  tags   = merge(var.tags, { Name = "\${var.prefix}-\${var.env}-igw" })
}

resource "aws_route" "internet_access" {
  route_table_id         = var.route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

output "igw_id" {
  value = aws_internet_gateway.igw.id
}
