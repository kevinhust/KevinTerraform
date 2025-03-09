# Get VPC information
data "aws_vpc" "selected" {
  tags = {
    Name = "${var.prefix}-${var.env}-vpc"
  }
}

# Get subnet information
data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
  filter {
    name   = "tag:Name"
    values = ["${var.prefix}-${var.env}-private-*"]
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
  filter {
    name   = "tag:Name"
    values = ["${var.prefix}-${var.env}-public-*"]
  }
}

# Define local tags
locals {
  default_tags = merge(var.default_tags, { "env" = var.env })
}

# Deploy VMs (VM1 and VM2) for non-prod environment
module "vm_nonprod" {
  source         = "../../../modules/vm"
  instance_count = 2
  instance_type  = lookup(var.instance_type, var.env)
  subnet_ids     = data.aws_subnets.private.ids
  vpc_id         = data.aws_vpc.selected.id
  env            = var.env
  tags           = local.default_tags
  bastion_cidr   = var.vpc_cidr
  prefix         = var.prefix
  key_name       = "kevin-terraform-key"
  is_bastion     = false
}

# Deploy Load Balancer between VM1 and VM2
module "load_balancer_nonprod" {
  source     = "../../../modules/load_balancer"
  vpc_id     = data.aws_vpc.selected.id
  subnet_ids = data.aws_subnets.public.ids
  vm_ids     = module.vm_nonprod.vm_ids
  env        = var.env
  tags       = local.default_tags
  prefix     = var.prefix
}

# Add outputs
output "vm_private_ips" {
  description = "Private IP addresses of the VMs"
  value       = module.vm_nonprod.private_ips
}

output "lb_dns" {
  description = "DNS name of the load balancer"
  value       = module.load_balancer_nonprod.lb_dns
}

output "vm_ids" {
  description = "Instance IDs of the VMs"
  value       = module.vm_nonprod.vm_ids
}
