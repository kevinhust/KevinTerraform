resource "aws_lb" "main" {
  name               = "\${var.prefix}-\${var.env}-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.subnet_ids
  security_groups    = [aws_security_group.lb_sg.id]
  tags               = var.tags
}

resource "aws_security_group" "lb_sg" {
  name        = "\${var.prefix}-\${var.env}-lb-sg"
  description = "Security group for Load Balancer in \${var.env}"
  vpc_id      = var.vpc_id
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
  name     = "\${var.prefix}-\${var.env}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
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
