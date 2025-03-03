module "vm" {
  source         = "../../../modules/vm"
  instance_count = 2
  instance_type  = "t2.micro"
  subnet_ids     = var.private_subnet_ids
  env            = "non-prod"
  tags           = var.tags
  bastion_cidr   = var.vpc_cidr
}

module "load_balancer" {
  source     = "../../../modules/load_balancer"
  vpc_id     = var.vpc_id
  subnet_ids = var.public_subnet_ids
  vm_ids     = module.vm.vm_ids
  env        = "non-prod"
  tags       = var.tags
}