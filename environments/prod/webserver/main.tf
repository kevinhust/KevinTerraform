# Define local tags
locals {
  default_tags = merge(var.default_tags, { "env" = var.env })
}

# Deploy VMs (VM1 and VM2) for prod environment
module "vm_prod" {
  source         = "../../modules/vm"
  instance_count = 2
  instance_type  = lookup(var.instance_type, var.env)
  subnet_ids     = var.private_subnet_ids
  vpc_id         = var.vpc_id
  env            = var.env
  tags           = local.default_tags
  bastion_cidr   = var.vpc_cidr
  prefix         = var.prefix
  key_name       = "kevin-terraform-key"
  is_bastion     = false
}

# Deploy Load Balancer between VM1 and VM2
module "load_balancer_prod" {
  source     = "../../modules/load_balancer"
  vpc_id     = var.vpc_id
  subnet_ids = var.public_subnet_ids
  vm_ids     = module.vm_prod.vm_ids
  env        = var.env
  tags       = local.default_tags
  prefix     = var.prefix
}
