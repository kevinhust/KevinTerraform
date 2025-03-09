output "vpc_id" {
  value = module.vpc_prod.vpc_id
}

output "subnet_ids" {
  value = module.subnet_prod.subnet_ids
}

output "bastion_ids" {
  value = module.bastion_prod.vm_ids
}

output "bastion_public_ips" {
  value = module.bastion_prod.public_ips
}
