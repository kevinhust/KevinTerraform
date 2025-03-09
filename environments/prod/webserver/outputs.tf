output "vm_ids" {
  description = "Instance IDs of the VMs"
  value = module.vm_prod.vm_ids
}

output "vm_private_ips" {
  description = "Private IP addresses of the VMs"
  value = module.vm_prod.private_ips
}
