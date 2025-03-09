output "vpc_id" {
  value = module.vpc_nonprod.vpc_id
}

output "subnet_ids" {
  value = module.subnet_nonprod.subnet_ids
}

output "bastion_ids" {
  value = module.bastion_nonprod.vm_ids
}

output "bastion_public_ips" {
  value = module.bastion_nonprod.public_ips
}
