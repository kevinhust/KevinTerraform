# Get VPC information
data "aws_vpc" "selected" {
  tags = {
    Name = "${var.prefix}-${var.env}-vpc"
  }
}

# Get private subnet 1 (10.1.3.0/24)
data "aws_subnet" "private_1" {
  vpc_id = data.aws_vpc.selected.id
  filter {
    name   = "tag:Name"
    values = ["${var.prefix}-${var.env}-private-1"]
  }
}

# Get private subnet 2 (10.1.4.0/24)
data "aws_subnet" "private_2" {
  vpc_id = data.aws_vpc.selected.id
  filter {
    name   = "tag:Name"
    values = ["${var.prefix}-${var.env}-private-2"]
  }
}

# Get public subnets for load balancer
data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
  filter {
    name   = "tag:Name"
    values = ["${var.prefix}-${var.env}-public-*"]
  }
}

# Get bastion security group
data "aws_security_group" "bastion" {
  tags = {
    Name = "${var.prefix}-${var.env}-bastion-sg"
  }
}

# Define local tags
locals {
  default_tags = merge(var.default_tags, { "env" = var.env })
}

# Deploy VMs (VM1 in Private subnet 1, VM2 in Private subnet 2)
module "vm_nonprod" {
  source         = "../../../modules/vm"
  instance_count = 2
  instance_type  = lookup(var.instance_type, var.env)
  subnet_ids     = [data.aws_subnet.private_1.id, data.aws_subnet.private_2.id]  # Explicitly order subnets
  vpc_id         = data.aws_vpc.selected.id
  env            = var.env
  tags           = var.default_tags
  bastion_sg     = data.aws_security_group.bastion.id
  prefix         = var.prefix
  key_name       = "kevin-terraform-key"
  is_bastion     = false
}

# Deploy Load Balancer in Public subnets for high availability
module "load_balancer_nonprod" {
  source     = "../../../modules/load_balancer"
  vpc_id     = data.aws_vpc.selected.id
  subnet_ids = data.aws_subnets.public.ids  # Deploy in both public subnets for HA
  vm_ids     = module.vm_nonprod.vm_ids
  env        = var.env
  tags       = var.default_tags
  prefix     = var.prefix
}
