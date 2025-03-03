# Create VPC for prod environment
module "vpc" {
  source   = "../../../modules/vpc"
  vpc_cidr = var.vpc_cidr
  env      = var.env
  tags     = var.default_tags
  prefix   = var.prefix
}

# Create subnets for prod environment
module "subnet" {
  source          = "../../../modules/subnet"
  vpc_id          = module.vpc.vpc_id
  subnet_cidrs    = var.private_subnet_cidrs
  azs             = var.azs
  env             = var.env
  tags            = var.default_tags
  prefix          = var.prefix
}

# Create private route table for prod environment
resource "aws_route_table" "private_rt" {
  vpc_id = module.vpc.vpc_id
  tags   = merge(var.default_tags, { Name = "${var.prefix}-${var.env}-private-rt" })
}

# Associate private subnets with private route table
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = element(module.subnet.subnet_ids, count.index)
  route_table_id = aws_route_table.private_rt.id
}