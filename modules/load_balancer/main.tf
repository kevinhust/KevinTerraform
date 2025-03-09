# Create Application Load Balancer
resource "aws_lb" "alb" {
  name               = "${var.prefix}-${var.env}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.subnet_ids

  tags = merge(var.tags, {
    Name = "${var.prefix}-${var.env}-alb"
  })
}

# Create ALB Security Group
resource "aws_security_group" "alb" {
  name        = "${var.prefix}-${var.env}-alb-sg"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id

  # Allow HTTP traffic from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP from anywhere"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = merge(var.tags, {
    Name = "${var.prefix}-${var.env}-alb-sg"
  })
}

# Create target group
resource "aws_lb_target_group" "tg" {
  name     = "${var.prefix}-${var.env}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher            = "200"
    path               = "/"
    port               = "traffic-port"
    protocol           = "HTTP"
    timeout            = 5
    unhealthy_threshold = 2
  }

  tags = merge(var.tags, {
    Name = "${var.prefix}-${var.env}-tg"
  })
}

# Attach EC2 instances to target group
resource "aws_lb_target_group_attachment" "tg_attachment" {
  count            = length(var.vm_ids)
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = var.vm_ids[count.index]
  port             = 80
}

# Create listener
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
