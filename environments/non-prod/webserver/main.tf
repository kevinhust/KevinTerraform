# Define local tags
locals {
  default_tags = merge(var.default_tags, { "env" = var.env })
}

# Deploy VMs (VM1 and VM2) for non-prod environment
module "vm_nonprod" {
  source         = "../../modules"
  instance_count = 2
  instance_type  = lookup(var.instance_type, var.env)
  subnet_ids     = var.private_subnet_ids
  env            = var.env
  tags           = local.default_tags
  bastion_cidr   = var.vpc_cidr
  prefix         = var.prefix
  key_name       = "kevin-terraform-key"
  vpc_cidr       = var.vpc_cidr  # Pass to vpc resource in the module
}

# Deploy Load Balancer between VM1 and VM2
module "load_balancer_nonprod" {
  source     = "../../modules"
  vpc_cidr   = var.vpc_cidr  # Pass to vpc resource in the module
  subnet_ids = var.public_subnet_ids
  vm_ids     = module.vm_nonprod.vm_ids
  env        = var.env
  tags       = local.default_tags
  prefix     = var.prefix
}