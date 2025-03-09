output "vm_ids" {
  description = "List of VM instance IDs"
  value       = aws_instance.vm[*].id
}

output "public_ips" {
  description = "List of public IP addresses assigned to the instances"
  value       = aws_instance.vm[*].public_ip
}

output "private_ips" {
  description = "List of private IP addresses assigned to the instances"
  value       = aws_instance.vm[*].private_ip
}