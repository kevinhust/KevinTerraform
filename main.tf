# Manage SSH key pair (manually generated and imported)
resource "aws_key_pair" "kevin_terraform_key" {
  key_name   = "kevin-terraform-key"
  public_key = file("${path.root}/kevin-terraform-key.pub")
}

# Save the private key to a .pem file (for local SSH use only)
resource "local_file" "private_key" {
  content         = file("${path.root}/kevin-terraform-key")
  filename        = "${path.root}/kevin-terraform-key.pem"
  file_permission = "0600"
}

output "kevin_terraform_key_pem_path" {
  value     = "${path.root}/kevin-terraform-key.pem"
  sensitive = true
}