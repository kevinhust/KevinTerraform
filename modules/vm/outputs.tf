output "vm_ids" {
  value       = aws_instance.vm[*].id
  description = "List of IDs for the VMs or Bastion instances"
}

output "public_ips" {
  value       = aws_instance.vm[*].public_ip
  description = "List of public IPs for the VMs or Bastion instances"
}

output "private_ips" {
  value       = aws_instance.vm[*].private_ip
  description = "List of private IPs for the VMs or Bastion instances"
}