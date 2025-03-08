# Output VPC ID
output "vpc_id" {
  value = module.vpc_prod.vpc_id
}

# Output public subnet IDs
output "public_subnet_ids" {
  value = slice(module.subnet_prod.subnet_ids, 0, length(var.public_subnet_cidrs))
}

# Output private subnet IDs
output "private_subnet_ids" {
  value = slice(module.subnet_prod.subnet_ids, length(var.public_subnet_cidrs), length(module.subnet_prod.subnet_ids))
}

# Output VPC CIDR for reference
output "vpc_cidr" {
  value = var.vpc_cidr
}