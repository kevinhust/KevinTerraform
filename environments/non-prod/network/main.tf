# Create VPC for non-prod environment
module "vpc_nonprod" {
  source   = "../../../modules/vpc"
  vpc_cidr = var.vpc_cidr
  env      = var.env
  tags     = var.default_tags
  prefix   = var.prefix
}

# Create subnets for non-prod environment (2 public, 2 private)
module "subnet_nonprod" {
  source              = "../../../modules/subnet"
  vpc_id              = module.vpc_nonprod.vpc_id
  subnet_cidrs        = concat(var.public_subnet_cidrs, var.private_subnet_cidrs)
  public_subnet_cidrs = var.public_subnet_cidrs
  azs                 = var.azs
  env                 = var.env
  tags                = var.default_tags
  prefix              = var.prefix
}

# Create Internet Gateway for non-prod environment
module "internet_gw_nonprod" {
  source         = "../../../modules/internet_gateway"
  vpc_id         = module.vpc_nonprod.vpc_id
  route_table_id = aws_route_table.public_rt_nonprod.id
  env            = var.env
  tags           = var.default_tags
  prefix         = var.prefix
}

# Create NAT Gateway for non-prod private subnets (in Public subnet 1)
module "nat_gw_nonprod" {
  source                 = "../../../modules/nat_gateway"
  public_subnet_id       = element(module.subnet_nonprod.subnet_ids, 0)  # Public subnet 1 (10.1.1.0/24)
  private_route_table_id = aws_route_table.private_rt_nonprod.id
  env                    = var.env
  tags                   = var.default_tags
  prefix                 = var.prefix
}

# Create Bastion Host in Public subnet 2
module "bastion_nonprod" {
  source         = "../../../modules/vm"
  instance_count = 1
  instance_type  = "t2.micro"
  subnet_ids     = [element(module.subnet_nonprod.subnet_ids, 1)]  # Public subnet 2 (10.1.2.0/24)
  vpc_id         = module.vpc_nonprod.vpc_id
  env            = var.env
  tags           = var.default_tags
  prefix         = var.prefix
  key_name       = "kevin-terraform-key"
  is_bastion     = true
}

# Create public route table for non-prod environment
resource "aws_route_table" "public_rt_nonprod" {
  vpc_id = module.vpc_nonprod.vpc_id
  tags   = merge(var.default_tags, { Name = "${var.prefix}-${var.env}-public-rt" })
}

# Associate public subnets with public route table
resource "aws_route_table_association" "public_nonprod" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(module.subnet_nonprod.subnet_ids, count.index)
  route_table_id = aws_route_table.public_rt_nonprod.id
}

# Create private route table for non-prod environment
resource "aws_route_table" "private_rt_nonprod" {
  vpc_id = module.vpc_nonprod.vpc_id
  tags   = merge(var.default_tags, { Name = "${var.prefix}-${var.env}-private-rt" })
}

# Associate private subnets with private route table
resource "aws_route_table_association" "private_nonprod" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = element(module.subnet_nonprod.subnet_ids, count.index + length(var.public_subnet_cidrs))
  route_table_id = aws_route_table.private_rt_nonprod.id
}
