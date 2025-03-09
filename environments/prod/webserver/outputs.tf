output "vm_ids" {
  value = module.vm_prod.vm_ids
}

output "vm_public_ips" {
  value = module.vm_prod.public_ips
}

output "lb_dns" {
  value = module.load_balancer_prod.lb_dns
}
