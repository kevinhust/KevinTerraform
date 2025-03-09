output "vpc_id" {
  value = module.vpc_prod.vpc_id
}

output "private_subnet_ids" {
  value = module.subnet_prod.subnet_ids
}

output "vpc_cidr" {
  value = var.vpc_cidr
}
