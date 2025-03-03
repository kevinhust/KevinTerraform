module "vpc" {
  source   = "../../../modules/vpc"
  vpc_cidr = var.vpc_cidr
  env      = "prod"
  tags     = var.tags
}

module "subnet" {
  source          = "../../../modules/subnet"
  vpc_id          = module.vpc.vpc_id
  subnet_cidrs    = var.private_subnet_cidrs
  azs             = var.azs
  env             = "prod"
  tags            = var.tags
}

resource "aws_route_table" "private_rt" {
  vpc_id = module.vpc.vpc_id

  tags = merge(
    var.tags,
    { Name = "prod-private-rt" }
  )
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = element(module.subnet.subnet_ids, count.index)
  route_table_id = aws_route_table.private_rt.id
}