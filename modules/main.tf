# VPC Module
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags       = merge(var.tags, { Name = "${var.prefix}-${var.env}-vpc" })
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

# Subnet Module
resource "aws_subnet" "subnet" {
  count                   = length(var.subnet_cidrs)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet_cidrs[count.index]
  availability_zone       = element(var.azs, count.index % length(var.azs))
  map_public_ip_on_launch = count.index < length(var.public_subnet_cidrs) ? true : false
  tags                    = merge(var.tags, { Name = "${var.prefix}-${var.env}-subnet-${count.index}" })
}

output "subnet_ids" {
  value = aws_subnet.subnet[*].id
}

# Internet Gateway Module
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags   = merge(var.tags, { Name = "${var.prefix}-${var.env}-igw" })
}

resource "aws_route" "internet_access" {
  route_table_id         = var.route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

output "igw_id" {
  value = aws_internet_gateway.igw.id
}

# NAT Gateway Module
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = var.public_subnet_id
  tags          = merge(var.tags, { Name = "${var.prefix}-${var.env}-nat-gw" })
}

resource "aws_route" "nat_route" {
  route_table_id         = var.private_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
}

output "nat_gw_id" {
  value = aws_nat_gateway.nat_gw.id
}

# Virtual Machine Module
resource "aws_instance" "vm" {
  count                  = var.instance_count
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = element(var.subnet_ids, count.index % length(var.subnet_ids))
  user_data              = var.env == "non-prod" ? file("${path.module}/../install_apache.sh") : null
  vpc_security_group_ids = [aws_security_group.vm_sg.id]
  key_name               = var.key_name

  tags = merge(var.tags, { Name = "${var.prefix}-${var.env}-vm-${count.index}" })
}

resource "aws_security_group" "vm_sg" {
  name        = "${var.prefix}-${var.env}-vm-sg"
  description = "Security group for VMs in ${var.env}"
  vpc_id      = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = var.env == "non-prod" ? [
      { from_port = 22, to_port = 22, protocol = "tcp", cidr_blocks = [var.bastion_cidr] },
      { from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] }
    ] : [
      { from_port = 22, to_port = 22, protocol = "tcp", cidr_blocks = [var.bastion_cidr] }
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

output "vm_ids" {
  value = aws_instance.vm[*].id
}

output "public_ips" {
  value = aws_instance.vm[*].public_ip
}

output "private_ips" {
  value = aws_instance.vm[*].private_ip
}

# Load Balancer Module
resource "aws_lb" "main" {
  name               = "${var.prefix}-${var.env}-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.subnet_ids
  security_groups    = [aws_security_group.lb_sg.id]
  tags               = var.tags
}

resource "aws_security_group" "lb_sg" {
  name        = "${var.prefix}-${var.env}-lb-sg"
  description = "Security group for Load Balancer in ${var.env}"
  vpc_id      = aws_vpc.vpc.id

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

  tags = var.tags
}

resource "aws_lb_target_group" "main" {
  name     = "${var.prefix}-${var.env}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

resource "aws_lb_target_group_attachment" "attachment" {
  count            = length(var.vm_ids)
  target_group_arn = aws_lb_target_group.main.arn
  target_id        = element(var.vm_ids, count.index)
  port             = 80
}

output "lb_dns" {
  value = aws_lb.main.dns_name
}