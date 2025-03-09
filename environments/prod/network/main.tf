# Create VPC for prod environment
module "vpc_prod" {
  source   = "../../modules/vpc"
  vpc_cidr = var.vpc_cidr
  env      = var.env
  tags     = var.default_tags
  prefix   = var.prefix
}

# Create subnets for prod environment (2 public, 2 private)
module "subnet_prod" {
  source             = "../../modules/subnet"
  vpc_id             = module.vpc_prod.vpc_id
  subnet_cidrs       = concat(var.public_subnet_cidrs, var.private_subnet_cidrs)
  public_subnet_cidrs = var.public_subnet_cidrs
  azs                = var.azs
  env                = var.env
  tags               = var.default_tags
  prefix             = var.prefix
}

# Create Internet Gateway for prod environment
module "internet_gw_prod" {
  source         = "../../modules/internet_gateway"
  vpc_id         = module.vpc_prod.vpc_id
  route_table_id = aws_route_table.public_rt_prod.id
  env            = var.env
  tags           = var.default_tags
  prefix         = var.prefix
}

# Create NAT Gateway for prod private subnets
module "nat_gw_prod" {
  source                 = "../../modules/nat_gateway"
  public_subnet_id       = element(module.subnet_prod.subnet_ids, 0)
  private_route_table_id = aws_route_table.private_rt_prod.id
  env                    = var.env
  tags                   = var.default_tags
  prefix                 = var.prefix
}

# Create Bastion Host for SSH access to private subnets (using vm module with is_bastion = true)
module "bastion_prod" {
  source         = "../../modules/vm"
  instance_count = 1
  instance_type  = "t3.medium"
  subnet_ids     = [element(module.subnet_prod.subnet_ids, 0)]
  vpc_id         = module.vpc_prod.vpc_id
  env            = var.env
  tags           = var.default_tags
  bastion_cidr   = var.vpc_cidr
  prefix         = var.prefix
  key_name       = "kevin-terraform-key"
  is_bastion     = true
}

# Create public route table for prod environment
resource "aws_route_table" "public_rt_prod" {
  vpc_id = module.vpc_prod.vpc_id
  tags   = merge(var.default_tags, { Name = "\${var.prefix}-\${var.env}-public-rt" })
}

# Associate public subnets with public route table
resource "aws_route_table_association" "public_prod" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(module.subnet_prod.subnet_ids, count.index)
  route_table_id = aws_route_table.public_rt_prod.id
}

# Create private route table for prod environment
resource "aws_route_table" "private_rt_prod" {
  vpc_id = module.vpc_prod.vpc_id
  tags   = merge(var.default_tags, { Name = "\${var.prefix}-\${var.env}-private-rt" })
}

# Associate private subnets with private route table
resource "aws_route_table_association" "private_prod" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = element(module.subnet_prod.subnet_ids, count.index + length(var.public_subnet_cidrs))
  route_table_id = aws_route_table.private_rt_prod.id
}
