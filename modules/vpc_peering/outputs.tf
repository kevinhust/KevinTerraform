output "vpc_peering_id" {
  description = "ID of the created VPC peering connection"
  value       = aws_vpc_peering_connection.peer.id
}

output "peering_connection_id" {
  description = "ID of the created VPC peering connection (alias)"
  value       = aws_vpc_peering_connection.peer.id
}

output "vpc_peering_status" {
  description = "Status of the VPC peering connection"
  value       = aws_vpc_peering_connection.peer.accept_status
}

output "requester_vpc_id" {
  description = "Requester VPC ID"
  value       = var.requester_vpc_id
}

output "accepter_vpc_id" {
  description = "Accepter VPC ID"
  value       = var.accepter_vpc_id
}

output "requester_routes_count" {
  description = "Number of routes created for the requester VPC"
  value       = length(aws_route.requester_public) + length(aws_route.requester_private)
}

output "accepter_routes_count" {
  description = "Number of routes created for the accepter VPC"
  value       = length(aws_route.accepter_public) + length(aws_route.accepter_private)
} 