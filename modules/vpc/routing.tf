resource "aws_route_table" "public_rt" {
  count  = local.enabled ? 1 : 0
  vpc_id = aws_vpc.finlife_vpc[0].id

  tags = merge(local.tags, { Name = "${local.id}-public-rt" })
}

resource "aws_route" "public_internet_route" {
  count                  = local.enabled ? 1 : 0
  route_table_id         = aws_route_table.public_rt[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw[0].id
}

resource "aws_route_table_association" "public_assoc" {
  count          = local.enabled ? length(var.public_subnet_cidrs) : 0
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rt[0].id
}

resource "aws_route_table" "private_rt" {
  count  = local.enabled ? 1 : 0
  vpc_id = aws_vpc.finlife_vpc[0].id

  tags = merge(local.tags, { Name = "${local.id}-private-rt" })
}

resource "aws_route" "private_tgw_route" {
  count                  = local.enabled ? 1 : 0
  route_table_id         = aws_route_table.private_rt[0].id
  destination_cidr_block = "10.0.0.0/8"
  transit_gateway_id     = aws_ec2_transit_gateway.tgw[0].id
}

resource "aws_route_table_association" "private_assoc" {
  count          = local.enabled ? length(var.private_subnet_cidrs) : 0
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_rt[0].id
}