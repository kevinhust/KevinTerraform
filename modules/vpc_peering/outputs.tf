# Output peering connection ID
output "peering_id" {
  value = aws_vpc_peering_connection.peer.id
}