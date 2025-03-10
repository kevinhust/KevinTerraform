output "vpc_id" {
  description = "The ID of the non-production VPC"
  value       = module.vpc_nonprod.vpc_id
}

output "subnet_ids" {
  description = "List of subnet IDs in the non-production VPC"
  value       = module.subnet_nonprod.subnet_ids
}

output "bastion_ids" {
  description = "List of bastion host instance IDs"
  value       = module.bastion_nonprod.vm_ids
}

output "bastion_public_ips" {
  description = "List of public IP addresses of bastion hosts"
  value       = module.bastion_nonprod.public_ips
}
