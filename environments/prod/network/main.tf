# Create VPC for prod environment
module "vpc_prod" {
  source   = "../../../modules/vpc"
  vpc_cidr = var.vpc_cidr
  env      = var.env
  tags     = var.default_tags
  prefix   = var.prefix
}

# Create subnets for prod environment (only private subnets)
module "subnet_prod" {
  source             = "../../../modules/subnet"
  vpc_id             = module.vpc_prod.vpc_id
  subnet_cidrs       = var.private_subnet_cidrs
  public_subnet_cidrs = []  # 生产环境不需要公共子网
  azs                = var.azs
  env                = var.env
  tags               = var.default_tags
  prefix             = var.prefix
}

# Create Internet Gateway for prod environment
resource "aws_internet_gateway" "igw_prod" {
  vpc_id = module.vpc_prod.vpc_id

  tags = merge(var.default_tags, {
    Name = "${var.prefix}-${var.env}-igw"
  })
}

# Create private route table for prod environment
resource "aws_route_table" "private_rt_prod" {
  vpc_id = module.vpc_prod.vpc_id
  tags   = merge(var.default_tags, { Name = "${var.prefix}-${var.env}-private-rt" })
}

# Associate private subnets with private route table
resource "aws_route_table_association" "private_prod" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = module.subnet_prod.subnet_ids[count.index]
  route_table_id = aws_route_table.private_rt_prod.id
}

# Get non-prod VPC information
data "aws_vpc" "non_prod" {
  tags = {
    Name = "${var.prefix}-non-prod-vpc"
  }
}

data "aws_route_tables" "non_prod_public" {
  vpc_id = data.aws_vpc.non_prod.id
  tags = {
    Name = "${var.prefix}-non-prod-public-rt"
  }
}

data "aws_route_tables" "non_prod_private" {
  vpc_id = data.aws_vpc.non_prod.id
  tags = {
    Name = "${var.prefix}-non-prod-private-rt"
  }
}

# Create VPC Peering connection
module "vpc_peering" {
  source = "../../../modules/vpc_peering"

  prefix        = var.prefix
  env_requester = var.env
  env_accepter  = "non-prod"

  requester_vpc_id = module.vpc_prod.vpc_id
  accepter_vpc_id  = data.aws_vpc.non_prod.id

  requester_vpc_cidr = var.vpc_cidr
  accepter_vpc_cidr  = "10.0.0.0/16"  # non-prod VPC CIDR

  requester_private_route_table_id = aws_route_table.private_rt_prod.id
  accepter_public_route_table_id  = tolist(data.aws_route_tables.non_prod_public.ids)[0]
  accepter_private_route_table_id = tolist(data.aws_route_tables.non_prod_private.ids)[0]

  tags = var.default_tags
}
