module "vm" {
  source         = "../../../modules/vm"
  instance_count = 2
  instance_type  = "t2.medium"
  subnet_ids     = var.private_subnet_ids
  env            = "prod"
  tags           = var.tags
  bastion_cidr   = var.vpc_cidr
}