# Get VPC information
data "aws_vpc" "selected" {
  tags = {
    Name = "${var.prefix}-${var.env}-vpc"
  }
}

# Get private subnet 1 (10.10.1.0/24)
data "aws_subnet" "private_1" {
  vpc_id = data.aws_vpc.selected.id
  filter {
    name   = "tag:Name"
    values = ["${var.prefix}-${var.env}-private-1"]
  }
}

# Get private subnet 2 (10.10.2.0/24)
data "aws_subnet" "private_2" {
  vpc_id = data.aws_vpc.selected.id
  filter {
    name   = "tag:Name"
    values = ["${var.prefix}-${var.env}-private-2"]
  }
}

# Get bastion security group from non-prod environment
data "aws_security_group" "bastion" {
  tags = {
    Name = "${var.prefix}-non-prod-bastion-sg"
  }
}

# Define local tags
locals {
  default_tags = merge(var.default_tags, { "env" = var.env })
}

# Deploy VMs (VM1 in Private subnet 1, VM2 in Private subnet 2)
module "vm_prod" {
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
