# Import manually generated SSH public key into AWS
resource "aws_key_pair" "kevin_terraform_key" {
  key_name   = "kevin-terraform-key"
  public_key = file("${path.root}/kevin-terraform-key.pub")
}

# Save the private key to a PEM file for local SSH access
resource "local_file" "private_key" {
  content         = file("${path.root}/kevin-terraform-key")
  filename        = "${path.root}/kevin-terraform-key.pem"
  file_permission = "0600"
}

# Output the path to the private key file for reference
output "kevin_terraform_key_pem_path" {
  value     = "${path.root}/kevin-terraform-key.pem"
  sensitive = true
}