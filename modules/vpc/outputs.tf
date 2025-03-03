# Output VPC ID
output "vpc_id" {
  value = aws_vpc.main.id
}

# Output VPC CIDR
output "vpc_cidr" {
  value = aws_vpc.main.cidr_block
}