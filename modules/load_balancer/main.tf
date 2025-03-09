# 创建应用负载均衡器
resource "aws_lb" "alb" {
  name               = "${var.prefix}-${var.env}-alb"
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets           = var.subnet_ids

  tags = merge(var.tags, {
    Name = "${var.prefix}-${var.env}-alb"
  })
}

# 创建目标组
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

# 将EC2实例添加到目标组
resource "aws_lb_target_group_attachment" "tg_attachment" {
  count            = length(var.vm_ids)
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = var.vm_ids[count.index]
  port             = 80
}

# 创建监听器
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

# 创建ALB安全组
resource "aws_security_group" "alb_sg" {
  name        = "${var.prefix}-${var.env}-alb-sg"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.internal ? [var.vpc_cidr] : ["0.0.0.0/0"]  # 如果是内部ALB，只允许VPC内访问
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.prefix}-${var.env}-alb-sg"
  })
}
