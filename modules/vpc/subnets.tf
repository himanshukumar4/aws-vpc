resource "aws_subnet" "public_subnets" {
  count = local.enabled ? length(var.public_subnet_cidrs) : 0

  vpc_id                  = aws_vpc.finlife_vpc[0].id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(local.tags, {
    Name = "${local.id}-public-subnet-${count.index + 1}"
    Tier = "public"
  })
}

resource "aws_subnet" "private_subnets" {
  count = local.enabled ? length(var.private_subnet_cidrs) : 0

  vpc_id            = aws_vpc.finlife_vpc[0].id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(local.tags, {
    Name = "${local.id}-private-subnet-${count.index + 1}"
    Tier = "private"
  })
}