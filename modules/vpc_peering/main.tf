# Create VPC peering connection
resource "aws_vpc_peering_connection" "peer" {
  vpc_id        = var.vpc1_id
  peer_vpc_id   = var.vpc2_id
  auto_accept   = true
  tags          = merge(var.tags, { Name = "${var.prefix}-peering" })
}