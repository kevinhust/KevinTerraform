module "vpc" {
  source   = "../../../modules/vpc"
  vpc_cidr = var.vpc_cidr
  env      = "non-prod"
  tags     = var.tags
}

module "subnet" {
  source       = "../../../modules/subnet"
  vpc_id       = module.vpc.vpc_id
  subnet_cidrs = var.subnet_cidrs
  azs          = var.azs
  env          = "non-prod"
  tags         = var.tags
}

module "internet_gw" {
  source         = "../../../modules/internet_gw"
  vpc_id         = module.vpc.vpc_id
  route_table_id = aws_route_table.main.id
  env            = "non-prod"
  tags           = var.tags
}

resource "aws_route_table" "main" {
  vpc_id = module.vpc.vpc_id
}