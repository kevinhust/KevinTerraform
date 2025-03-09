resource "aws_instance" "vm" {
  count                  = var.instance_count
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_ids[count.index % length(var.subnet_ids)]
  vpc_security_group_ids = [aws_security_group.vm_sg.id]
  key_name              = var.key_name

  user_data = var.is_bastion ? null : file("${path.root}/../../install_apache.sh")

  tags = merge(var.tags, {
    Name = "${var.prefix}-${var.env}-${var.is_bastion ? "bastion" : "vm"}-${count.index + 1}"
  })
}

resource "aws_security_group" "vm_sg" {
  name        = "${var.prefix}-${var.env}-${var.is_bastion ? "bastion" : "vm"}-sg"
  description = "Security group for ${var.is_bastion ? "Bastion Host" : "VMs"} in ${var.env}"
  vpc_id      = var.vpc_id

  # SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.is_bastion ? ["0.0.0.0/0"] : [var.bastion_cidr]
  }

  # HTTP access
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.prefix}-${var.env}-${var.is_bastion ? "bastion" : "vm"}-sg"
  })
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}