resource "aws_instance" "vm" {
  count         = var.instance_count
  ami           = data.aws_ami.latest_amazon_linux.id
  instance_type = var.instance_type
  subnet_id     = element(var.subnet_ids, count.index % length(var.subnet_ids))

  tags = merge(
    var.tags,
    { Name = "${var.env}-vm-${count.index}" }
  )
}

data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}