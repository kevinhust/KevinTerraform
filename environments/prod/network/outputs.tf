# Output VPC ID
output "vpc_id" {
  value = module.vpc.vpc_id
}

# Output private subnet IDs
output "private_subnet_ids" {
  value = module.subnet.subnet_ids
}