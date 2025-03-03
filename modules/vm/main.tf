resource "aws_instance" "vm" {
  count         = var.instance_count
  ami           = data.aws_ami.latest_amazon_linux.id
  instance_type = var.instance_type
  subnet_id     = element(var.subnet_ids, count.index % length(var.subnet_ids))
  user_data     = var.env == "non-prod" ? file("${path.module}/scripts/install_apache.sh") : null
  vpc_security_group_ids = [aws_security_group.vm_sg.id]
  key_name      = aws_key_pair.kevin_terraform_key.key_name  # Use the manually imported key pair

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}-${var.env}-vm-${count.index}"
    }
  )
}

resource "aws_security_group" "vm_sg" {
  name        = "${var.prefix}-${var.env}-vm-sg"
  description = "Security group for VMs in ${var.env}"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.env == "non-prod" ? [
      {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [var.bastion_cidr]
      },
      {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ] : [
      {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [var.bastion_cidr]
      }
    ]

    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}