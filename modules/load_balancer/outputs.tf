output "lb_dns" {
  description = "DNS name of the load balancer"
  value       = aws_lb.alb.dns_name
}

output "lb_id" {
  description = "ID of the load balancer"
  value       = aws_lb.alb.id
}

output "target_group_arn" {
  description = "ARN of the target group"
  value       = aws_lb_target_group.tg.arn
}

output "security_group_id" {
  description = "ID of the load balancer security group"
  value       = aws_security_group.alb.id
}
