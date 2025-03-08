# Create VPC for prod environment
module "vpc_prod" {
  source   = "../../modules"
  vpc_cidr = var.vpc_cidr
  env      = var.env
  tags     = var.default_tags
  prefix   = var.prefix
}

# Create subnets for prod environment (2 public, 2 private)
module "subnet_prod" {
  source             = "../../modules"
  vpc_cidr           = var.vpc_cidr  # Pass to vpc resource in the module
  subnet_cidrs       = concat(var.public_subnet_cidrs, var.private_subnet_cidrs)
  public_subnet_cidrs = var.public_subnet_cidrs
  azs                = var.azs
  env                = var.env
  tags               = var.default_tags
  prefix             = var.prefix
}

# Create Internet Gateway for prod environment to ensure public access
module "internet_gw_prod" {
  source         = "../../modules"
  vpc_cidr       = var.vpc_cidr  # Pass to vpc resource in the module
  route_table_id = aws_route_table.public_rt_prod.id
  env            = var.env
  tags           = var.default_tags
  prefix         = var.prefix
}

# Create public route table for prod environment
resource "aws_route_table" "public_rt_prod" {
  vpc_id = module.vpc_prod.vpc_id
  tags   = merge(var.default_tags, { Name = "${var.prefix}-${var.env}-public-rt" })
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
  tags   = merge(var.default_tags, { Name = "${var.prefix}-${var.env}-private-rt" })
}

# Associate private subnets with private route table
resource "aws_route_table_association" "private_prod" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = element(module.subnet_prod.subnet_ids, count.index + length(var.public_subnet_cidrs))
  route_table_id = aws_route_table.private_rt_prod.id
}