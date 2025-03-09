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
  public_subnet_cidrs = []  # Production environment doesn't need public subnets
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

# Get non-prod VPC information
data "aws_vpc" "non_prod" {
  tags = {
    Name = "${var.prefix}-non-prod-vpc"
  }
}

# Get non-prod NAT Gateway information
data "aws_nat_gateway" "non_prod" {
  tags = {
    Name = "${var.prefix}-non-prod-nat"
  }
}

# Create private route table for prod environment
resource "aws_route_table" "private_rt_prod" {
  vpc_id = module.vpc_prod.vpc_id

  # Add route to Internet through Non-Prod NAT Gateway
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = data.aws_nat_gateway.non_prod.id
  }

  tags = merge(var.default_tags, { Name = "${var.prefix}-${var.env}-private-rt" })
}

# Associate private subnets with private route table
resource "aws_route_table_association" "private_prod" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = module.subnet_prod.subnet_ids[count.index]
  route_table_id = aws_route_table.private_rt_prod.id
}

# Get non-prod route tables
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

  requester_vpc_cidr = var.vpc_cidr        # 10.10.0.0/16
  accepter_vpc_cidr  = "10.1.0.0/16"      # non-prod VPC CIDR

  requester_public_route_table_id  = null  # Production has no public route table
  requester_private_route_table_id = aws_route_table.private_rt_prod.id
  
  accepter_public_route_table_id  = tolist(data.aws_route_tables.non_prod_public.ids)[0]
  accepter_private_route_table_id = tolist(data.aws_route_tables.non_prod_private.ids)[0]

  tags = var.default_tags
}
