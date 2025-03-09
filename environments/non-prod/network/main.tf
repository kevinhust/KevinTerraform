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
  source             = "../../../modules/subnet"
  vpc_id             = module.vpc_nonprod.vpc_id
  subnet_cidrs       = concat(var.public_subnet_cidrs, var.private_subnet_cidrs)
  public_subnet_cidrs = var.public_subnet_cidrs
  azs                = var.azs
  env                = var.env
  tags               = var.default_tags
  prefix             = var.prefix
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

# Create NAT Gateway for non-prod private subnets
module "nat_gw_nonprod" {
  source                 = "../../../modules/nat_gateway"
  public_subnet_id       = element(module.subnet_nonprod.subnet_ids, 0)
  private_route_table_id = aws_route_table.private_rt_nonprod.id
  env                    = var.env
  tags                   = var.default_tags
  prefix                 = var.prefix
}

# Create Bastion Host for SSH access to private subnets
module "bastion_nonprod" {
  source         = "../../../modules/vm"
  instance_count = 1
  instance_type  = "t2.micro"
  subnet_ids     = [element(module.subnet_nonprod.subnet_ids, 0)]
  vpc_id         = module.vpc_nonprod.vpc_id
  env            = var.env
  tags           = var.default_tags
  bastion_cidr   = var.vpc_cidr
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

# Get prod VPC information
# data "aws_vpc" "prod" {
#   tags = {
#     Name = "${var.prefix}-prod-vpc"
#   }
# }

# data "aws_route_tables" "prod_public" {
#   vpc_id = data.aws_vpc.prod.id
#   tags = {
#     Name = "${var.prefix}-prod-public-rt"
#   }
# }

# data "aws_route_tables" "prod_private" {
#   vpc_id = data.aws_vpc.prod.id
#   tags = {
#     Name = "${var.prefix}-prod-private-rt"
#   }
# }

# Create VPC Peering connection
# module "vpc_peering" {
#   source = "../../../modules/vpc_peering"

#   prefix        = var.prefix
#   env_requester = var.env
#   env_accepter  = "prod"

#   requester_vpc_id = module.vpc_nonprod.vpc_id
#   accepter_vpc_id  = data.aws_vpc.prod.id

#   requester_vpc_cidr = var.vpc_cidr
#   accepter_vpc_cidr  = "10.1.0.0/16"  # prod VPC CIDR

#   requester_public_route_table_id  = aws_route_table.public_rt_nonprod.id
#   requester_private_route_table_id = aws_route_table.private_rt_nonprod.id
  
#   accepter_public_route_table_id  = tolist(data.aws_route_tables.prod_public.ids)[0]
#   accepter_private_route_table_id = tolist(data.aws_route_tables.prod_private.ids)[0]

#   tags = var.default_tags
# }
