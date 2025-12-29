resource "aws_internet_gateway" "igw" {
  count  = local.enabled ? 1 : 0
  vpc_id = aws_vpc.finlife_vpc[0].id
  tags   = merge(local.tags, { Name = "${local.id}-igw" })
}

resource "aws_ec2_transit_gateway" "tgw" {
  count       = local.enabled ? 1 : 0
  description = "Regional TGW for ${local.id}"
  tags        = merge(local.tags, { Name = "${local.id}-tgw" })
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attachment" {
  count              = local.enabled ? 1 : 0
  subnet_ids         = aws_subnet.private_subnets[*].id
  transit_gateway_id = aws_ec2_transit_gateway.tgw[0].id
  vpc_id             = aws_vpc.finlife_vpc[0].id
}