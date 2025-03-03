# Define local tags combining default tags and environment
locals {
  default_tags = merge(var.default_tags, { "env" = var.env })
}

# Create web server VMs in non-prod private subnets
module "vm" {
  source         = "../../../modules/vm"
  instance_count = 2
  instance_type  = lookup(var.instance_type, var.env)
  subnet_ids     = var.private_subnet_ids
  env            = var.env
  tags           = local.default_tags
  bastion_cidr   = var.vpc_cidr
  prefix         = var.prefix
  key_name       = "kevin-terraform-key"
  vpc_id         = var.vpc_id
}

# Create load balancer for non-prod web servers
module "load_balancer" {
  source     = "../../../modules/load_balancer"
  vpc_id     = var.vpc_id
  subnet_ids = var.public_subnet_ids
  vm_ids     = module.vm.vm_ids
  env        = var.env
  tags       = local.default_tags
  prefix     = var.prefix
}