output "vm_ids" {
  value = aws_instance.vm[*].id
}