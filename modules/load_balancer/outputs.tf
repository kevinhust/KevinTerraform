# Output Load Balancer DNS name
output "lb_dns" {
  value = aws_lb.main.dns_name
}