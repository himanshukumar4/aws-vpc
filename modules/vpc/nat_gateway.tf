resource "aws_eip" "nat_eip" {
  count  = local.enabled && var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : length(var.availability_zones)) : 0
  domain = "vpc"

  tags = merge(local.tags, {
    Name = "${local.id}-nat-eip-${count.index + 1}"
  })

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat_gw" {
  count         = local.enabled && var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : length(var.availability_zones)) : 0
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.public_subnets[count.index].id

  tags = merge(local.tags, {
    Name = "${local.id}-nat-gw-${count.index + 1}"
  })

  depends_on = [aws_internet_gateway.igw]
}

# Route for private subnets to reach internet via NAT Gateway
resource "aws_route" "private_nat_route" {
  count                  = local.enabled && var.enable_nat_gateway ? length(var.private_subnet_cidrs) : 0
  route_table_id         = aws_route_table.private_rt[0].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.single_nat_gateway ? aws_nat_gateway.nat_gw[0].id : aws_nat_gateway.nat_gw[count.index].id
}
