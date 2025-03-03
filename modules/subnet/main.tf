# Create subnets
resource "aws_subnet" "subnet" {
  count             = length(var.subnet_cidrs)
  vpc_id            = var.vpc_id
  cidr_block        = var.subnet_cidrs[count.index]
  availability_zone = element(var.azs, count.index % length(var.azs))
  map_public_ip_on_launch = count.index < length(var.public_subnet_cidrs) ? true : false  # First subnets are public
  tags              = merge(var.tags, { Name = "${var.prefix}-${var.env}-subnet-${count.index}" })
}