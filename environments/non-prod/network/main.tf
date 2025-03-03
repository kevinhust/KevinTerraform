module "vpc" {
  source   = "../../../modules/vpc"
  vpc_cidr = var.vpc_cidr
  env      = "non-prod"
  tags     = var.tags
}

module "subnet" {
  source          = "../../../modules/subnet"
  vpc_id          = module.vpc.vpc_id
  subnet_cidrs    = concat(var.public_subnet_cidrs, var.private_subnet_cidrs)
  azs             = var.azs
  env             = "non-prod"
  tags            = var.tags
}

module "internet_gw" {
  source         = "../../../modules/internet_gw"
  vpc_id         = module.vpc.vpc_id
  route_table_id = aws_route_table.public_rt.id
  env            = "non-prod"
  tags           = var.tags
}

module "nat_gw" {
  source         = "../../../modules/nat_gw"
  vpc_id         = module.vpc.vpc_id
  public_subnet_id = element(module.subnet.subnet_ids, 0)
  private_route_table_id = aws_route_table.private_rt.id
  env            = "non-prod"
  tags           = var.tags
}

module "bastion" {
  source         = "../../../modules/vm"
  instance_count = 1
  instance_type  = "t2.micro"
  subnet_ids     = [element(module.subnet.subnet_ids, 0)]  # Public subnet
  env            = "non-prod"
  tags           = var.tags
  user_data      = null  # No additional packages
  bastion_cidr   = var.vpc_cidr
}

resource "aws_route_table" "public_rt" {
  vpc_id = module.vpc.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = module.internet_gw.igw_id
  }

  tags = merge(
    var.tags,
    { Name = "non-prod-public-rt" }
  )
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(module.subnet.subnet_ids, count.index)
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = module.vpc.vpc_id

  tags = merge(
    var.tags,
    { Name = "non-prod-private-rt" }
  )
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = element(module.subnet.subnet_ids, count.index + length(var.public_subnet_cidrs))
  route_table_id = aws_route_table.private_rt.id
}