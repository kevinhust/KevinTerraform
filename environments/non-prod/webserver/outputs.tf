output "public_ip" {
  value = module.vm_nonprod.public_ips
  description = "Public IP addresses of the VMs"
}

output "private_ip" {
  value = module.vm_nonprod.private_ips
  description = "Private IP addresses of the VMs"
}

output "vm_ids" {
  value = module.vm_nonprod.vm_ids
  description = "IDs of the VMs"
}

output "lb_dns" {
  value = module.load_balancer_nonprod.lb_dns
  description = "DNS name of the Load Balancer"
}