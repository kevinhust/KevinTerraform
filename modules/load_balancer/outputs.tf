output "lb_dns" {
  description = "DNS name of the load balancer"
  value       = aws_lb.main.dns_name
}
