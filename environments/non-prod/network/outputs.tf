# Output VPC ID
output "vpc_id" {
  value = module.vpc_nonprod.vpc_id
}

# Output public subnet IDs
output "public_subnet_ids" {
  value = slice(module.subnet_nonprod.subnet_ids, 0, length(var.public_subnet_cidrs))
}

# Output private subnet IDs
output "private_subnet_ids" {
  value = slice(module.subnet_nonprod.subnet_ids, length(var.public_subnet_cidrs), length(module.subnet_nonprod.subnet_ids))
}

# Output Bastion Host ID
output "bastion_id" {
  value = module.bastion_nonprod.vm_ids[0]
}

# Output VPC CIDR for reference
output "vpc_cidr" {
  value = var.vpc_cidr
}