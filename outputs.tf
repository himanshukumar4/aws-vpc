output "vpc_resource_outputs" {
  description = "Agnostic map of FinLife networking resource identifiers"
  value = {
    vpc_id              = module.vpc_layer.vpc_id
    public_subnets      = module.vpc_layer.public_subnet_ids
    private_subnets     = module.vpc_layer.private_subnet_ids
    transit_gateway_id  = module.vpc_layer.transit_gateway_id
    public_route_table  = module.vpc_layer.public_route_table_id
    private_route_table = module.vpc_layer.private_route_table_id
    nat_gateway_ids     = module.vpc_layer.nat_gateway_ids
    nat_eip_addresses   = module.vpc_layer.nat_eip_addresses
  }
}