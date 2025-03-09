resource "aws_eip" "nat_eip" {
  tags   = merge(var.tags, { Name = "${var.prefix}-${var.env}-nat-eip" })
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = var.public_subnet_id
  tags          = merge(var.tags, { Name = "${var.prefix}-${var.env}-nat-gw" })
}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = var.private_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
}
