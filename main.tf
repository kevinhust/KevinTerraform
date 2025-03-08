# Import manually generated SSH public key into AWS
resource "aws_key_pair" "kevin_terraform_key" {
  key_name   = "kevin-terraform-key"
  public_key = file("${path.root}/kevin-terraform-key.pub")
}
