# Output public IPs of web server instances
output "public_ip" {
  value = [for vm in module.vm.vm_ids : aws_instance.vm[0].public_ip]  # Adjust based on actual instance data
}

# Output VM IDs
output "vm_ids" {
  value = module.vm.vm_ids
}

# Output load balancer DNS name
output "lb_dns" {
  value = module.load_balancer.lb_dns
}