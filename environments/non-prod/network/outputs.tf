output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = slice(module.subnet.subnet_ids, 0, length(var.public_subnet_cidrs))
}

output "private_subnet_ids" {
  value = slice(module.subnet.subnet_ids, length(var.public_subnet_cidrs), length(module.subnet.subnet_ids))
}

output "bastion_id" {
  value = module.bastion.vm_ids[0]
}