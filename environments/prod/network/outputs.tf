output "vpc_id" {
  description = "The ID of the production VPC"
  value       = module.vpc_prod.vpc_id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs in the production VPC"
  value       = module.subnet_prod.subnet_ids
}

output "vpc_cidr" {
  description = "CIDR block of the production VPC"
  value       = var.vpc_cidr
}
