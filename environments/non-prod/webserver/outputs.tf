output "vm_ids" {
  value = module.vm_nonprod.vm_ids
}

output "vm_public_ips" {
  value = module.vm_nonprod.public_ips
}

output "lb_dns" {
  value = module.load_balancer_nonprod.lb_dns
}
