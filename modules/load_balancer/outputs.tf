output "lb_dns" {
  description = "DNS name of the load balancer"
  value       = aws_lb.alb.dns_name
}
