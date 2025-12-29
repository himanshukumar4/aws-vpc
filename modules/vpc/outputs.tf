output "vpc_id" { value = join("", aws_vpc.finlife_vpc[*].id) }
output "public_subnet_ids" { value = aws_subnet.public_subnets[*].id }
output "private_subnet_ids" { value = aws_subnet.private_subnets[*].id }
output "transit_gateway_id" { value = join("", aws_ec2_transit_gateway.tgw[*].id) }
output "public_route_table_id" { value = join("", aws_route_table.public_rt[*].id) }
output "private_route_table_id" { value = join("", aws_route_table.private_rt[*].id) }
output "nat_gateway_ids" { value = aws_nat_gateway.nat_gw[*].id }
output "nat_eip_addresses" { value = aws_eip.nat_eip[*].public_ip }