resource "aws_subnet" "subnet" {
  count                   = length(var.subnet_cidrs)
  vpc_id                  = var.vpc_id
  cidr_block              = var.subnet_cidrs[count.index]
  availability_zone       = var.azs[count.index % length(var.azs)]
  map_public_ip_on_launch = contains(var.public_subnet_cidrs, var.subnet_cidrs[count.index])
  
  # Calculate the subnet number based on environment and type
  tags = merge(var.tags, {
    Name = "${var.prefix}-${var.env}-${
      var.env == "prod" ? 
        (contains(var.public_subnet_cidrs, var.subnet_cidrs[count.index]) ? 
          "public-${count.index + 3}" : 
          "private-${count.index + 3}"
        ) :
        (contains(var.public_subnet_cidrs, var.subnet_cidrs[count.index]) ? 
          "public-${count.index + 1}" : 
          "private-${count.index - length(var.public_subnet_cidrs) + 1}"
        )
    }"
  })
}
