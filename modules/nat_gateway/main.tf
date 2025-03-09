resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = var.public_subnet_id
  tags          = merge(var.tags, { Name = "\${var.prefix}-\${var.env}-nat-gw" })
}

resource "aws_route" "nat_route" {
  route_table_id         = var.private_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
}

output "nat_gw_id" {
  value = aws_nat_gateway.nat_gw.id
}
