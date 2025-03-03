module "vm" {
  source         = "../../../modules/vm"
  instance_count = var.instance_count
  instance_type  = var.instance_type
  subnet_ids     = var.subnet_ids
  env            = "prod"
  tags           = var.tags
}

module "load_balancer" {
  source     = "../../../modules/load_balancer"
  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids
  env        = "prod"
  tags       = var.tags
}