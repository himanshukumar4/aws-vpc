module "vpc_layer" {
  source = "./modules/vpc/"

  enabled              = true
  namespace            = var.namespace
  environment          = var.environment
  stage                = var.stage
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  enable_nat_gateway   = var.enable_nat_gateway
  single_nat_gateway   = var.single_nat_gateway
}

module "rds_layer" {
  source = "./modules/rds/"

  enabled                    = var.enable_rds
  namespace                  = var.namespace
  environment                = var.environment
  stage                      = var.stage
  vpc_id                     = module.vpc_layer.vpc_id
  private_subnet_ids         = module.vpc_layer.private_subnet_ids
  engine_version             = var.rds_engine_version
  database_name              = var.rds_database_name
  master_username            = var.rds_master_username
  master_password            = var.rds_master_password
  db_instance_class          = var.rds_instance_class
  backup_retention_period    = var.rds_backup_retention
  multi_az                   = var.rds_multi_az
  publicly_accessible        = var.rds_publicly_accessible
  skip_final_snapshot        = var.rds_skip_final_snapshot
  enable_cloudwatch_logs     = var.rds_enable_cloudwatch_logs
  allowed_cidr_blocks        = var.rds_allowed_cidr_blocks
  enable_enhanced_monitoring = var.rds_enable_enhanced_monitoring
  monitoring_interval        = var.rds_monitoring_interval
  enable_global_database     = var.rds_enable_global_database
  primary_region             = var.rds_primary_region
  secondary_regions          = var.rds_secondary_regions
  secondary_vpc_ids          = var.rds_secondary_vpc_ids
  secondary_subnet_ids       = var.rds_secondary_subnet_ids

  depends_on = [module.vpc_layer]
}