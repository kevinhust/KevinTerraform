# Check if key pair exists
data "aws_key_pair" "existing_key" {
  key_name = var.key_name
}

resource "aws_instance" "vm" {
  count                  = var.instance_count
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_ids[count.index % length(var.subnet_ids)]
  vpc_security_group_ids = [aws_security_group.vm_sg.id]
  key_name              = data.aws_key_pair.existing_key.key_name

  user_data = var.is_bastion ? null : file("${path.module}/../../install_apache.sh")

  tags = merge(var.tags, {
    Name = var.is_bastion ? "${var.prefix}-${var.env}-bastion" : "${var.prefix}-${var.env}-vm-${count.index + 1}"
  })
}

resource "aws_security_group" "vm_sg" {
  name        = var.is_bastion ? "${var.prefix}-${var.env}-bastion-sg" : "${var.prefix}-${var.env}-vm-sg"
  description = "Security group for ${var.is_bastion ? "Bastion Host" : "VMs"} in ${var.env}"
  vpc_id      = var.vpc_id

  # SSH access
  dynamic "ingress" {
    for_each = var.is_bastion ? [1] : []
    content {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]  # Allow SSH access from anywhere for Bastion
      description = "Allow SSH from Internet"
    }
  }

  dynamic "ingress" {
    for_each = var.is_bastion ? [] : [1]
    content {
      from_port       = 22
      to_port         = 22
      protocol        = "tcp"
      security_groups = [var.bastion_sg]  # Allow SSH only from Bastion security group
      description     = "Allow SSH from Bastion host"
    }
  }

  # HTTP access for internal communication
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    self        = true  # Allow HTTP access between instances in the same security group
    description = "Allow HTTP within security group"
  }

  # HTTP access from other VPCs
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]  # Allow HTTP from all internal networks
    description = "Allow HTTP from internal networks"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = merge(var.tags, {
    Name = var.is_bastion ? "${var.prefix}-${var.env}-bastion-sg" : "${var.prefix}-${var.env}-vm-sg"
  })

  lifecycle {
    precondition {
      condition     = var.is_bastion || var.bastion_sg != null
      error_message = "bastion_sg must be provided for non-bastion instances"
    }
  }
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}