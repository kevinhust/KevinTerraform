# Output public IPs of web server instances
output "public_ip" {
  value = module.vm_prod.public_ips
  description = "Public IP addresses of the VMs"
}

# Output VM IDs
output "vm_ids" {
  value = module.vm_prod.vm_ids
  description = "IDs of the VMs"
}