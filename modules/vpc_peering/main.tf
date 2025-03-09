# Create VPC Peering connection
resource "aws_vpc_peering_connection" "peer" {
  vpc_id        = var.requester_vpc_id
  peer_vpc_id   = var.accepter_vpc_id
  auto_accept   = true

  tags = merge(var.tags, {
    Name = "${var.prefix}-${var.env_requester}-to-${var.env_accepter}-peering"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# Add routes to requester VPC route tables
resource "aws_route" "requester_public" {
  route_table_id            = var.requester_public_route_table_id
  destination_cidr_block    = var.accepter_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}

resource "aws_route" "requester_private" {
  route_table_id            = var.requester_private_route_table_id
  destination_cidr_block    = var.accepter_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id

  lifecycle {
    create_before_destroy = true
  }
}

# Add routes to accepter VPC route tables
resource "aws_route" "accepter_public" {
  route_table_id            = var.accepter_public_route_table_id
  destination_cidr_block    = var.requester_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route" "accepter_private" {
  route_table_id            = var.accepter_private_route_table_id
  destination_cidr_block    = var.requester_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id

  lifecycle {
    create_before_destroy = true
  }
} 