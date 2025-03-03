# Create VPC for non-prod environment
module "vpc" {
  source   = "../../../modules/vpc"
  vpc_cidr = var.vpc_cidr
  env      = var.env
  tags     = var.default_tags
  prefix   = var.prefix
}

# Create subnets for non-prod environment
module "subnet" {
  source          = "../../../modules/subnet"
  vpc_id          = module.vpc.vpc_id
  subnet_cidrs    = concat(var.public_subnet_cidrs, var.private_subnet_cidrs)
  azs             = var.azs
  env             = var.env
  tags            = var.default_tags
  prefix          = var.prefix
}

# Create Internet Gateway for non-prod environment
module "internet_gw" {
  source         = "../../../modules/internet_gw"
  vpc_id         = module.vpc.vpc_id
  route_table_id = aws_route_table.public_rt.id
  env            = var.env
  tags           = var.default_tags
  prefix         = var.prefix
}

# Create NAT Gateway for non-prod private subnets
module "nat_gw" {
  source                 = "../../../modules/nat_gw"
  vpc_id                 = module.vpc.vpc_id
  public_subnet_id       = element(module.subnet.subnet_ids, 0)
  private_route_table_id = aws_route_table.private_rt.id
  env                    = var.env
  tags                   = var.default_tags
  prefix                 = var.prefix
}

# Create Bastion Host for SSH access to private subnets
module "bastion" {
  source         = "../../../modules/vm"
  instance_count = 1
  instance_type  = "t2.micro"
  subnet_ids     = [element(module.subnet.subnet_ids, 0)]  # Public subnet
  env            = var.env
  tags           = var.default_tags
  bastion_cidr   = var.vpc_cidr
  prefix         = var.prefix
  vpc_id         = module.vpc.vpc_id
  key_name       = "kevin-terraform-key"
}

# Create public route table for non-prod environment
resource "aws_route_table" "public_rt" {
  vpc_id = module.vpc.vpc_id
  tags   = merge(var.default_tags, { Name = "${var.prefix}-${var.env}-public-rt" })
}

# Associate public subnets with public route table
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(module.subnet.subnet_ids, count.index)
  route_table_id = aws_route_table.public_rt.id
}

# Create private route table for non-prod environment
resource "aws_route_table" "private_rt" {
  vpc_id = module.vpc.vpc_id
  tags   = merge(var.default_tags, { Name = "${var.prefix}-${var.env}-private-rt" })
}

# Associate private subnets with private route table
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = element(module.subnet.subnet_ids, count.index + length(var.public_subnet_cidrs))
  route_table_id = aws_route_table.private_rt.id
}