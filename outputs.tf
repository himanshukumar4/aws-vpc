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

output "rds_resource_outputs" {
  description = "Aurora RDS cluster and instance outputs"
  sensitive   = true
  value = {
    cluster_id           = module.rds_layer.cluster_id
    cluster_endpoint     = module.rds_layer.cluster_endpoint
    reader_endpoint      = module.rds_layer.cluster_reader_endpoint
    database_name        = module.rds_layer.database_name
    master_username      = module.rds_layer.master_username
    instance_endpoints   = module.rds_layer.instance_endpoints
    security_group_id    = module.rds_layer.security_group_id
    db_subnet_group_name = module.rds_layer.db_subnet_group_name
    port                 = module.rds_layer.port
    arn                  = module.rds_layer.arn
  }
}