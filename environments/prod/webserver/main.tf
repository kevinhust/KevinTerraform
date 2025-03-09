# Get VPC information
data "aws_vpc" "selected" {
  tags = {
    Name = "${var.prefix}-${var.env}-vpc"
  }
}

# Get subnet information
data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
  filter {
    name   = "tag:Name"
    values = ["${var.prefix}-${var.env}-private-*"]
  }
}

# Define local tags
locals {
  default_tags = merge(var.default_tags, { "env" = var.env })
}

# Deploy VMs (VM1 and VM2) for prod environment
module "vm_prod" {
  source         = "../../../modules/vm"
  instance_count = 2
  instance_type  = lookup(var.instance_type, var.env)
  subnet_ids     = data.aws_subnets.private.ids
  vpc_id         = data.aws_vpc.selected.id
  env            = var.env
  tags           = var.default_tags
  bastion_cidr   = var.vpc_cidr
  prefix         = var.prefix
  key_name       = "kevin-terraform-key"
  is_bastion     = false
}
