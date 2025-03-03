resource "aws_subnet" "subnet" {
  count             = length(var.subnet_cidrs)
  vpc_id            = var.vpc_id
  cidr_block        = var.subnet_cidrs[count.index]
  availability_zone = element(var.azs, count.index)

  tags = merge(
    var.tags,
    { Name = "${var.env}-subnet-${count.index}" }
  )
}