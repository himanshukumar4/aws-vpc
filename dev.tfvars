namespace         = "finlife"
environment       = "us-east-1"
stage             = "dev"
aws_region        = "us-east-1"
target_account_id = "123456789012" # TODO: Replace with actual AWS Account ID

vpc_cidr             = "10.0.0.0/16"
availability_zones   = ["us-east-1a", "us-east-1b"]
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]

enable_nat_gateway = true
single_nat_gateway = false

# RDS Aurora Configuration
enable_rds                      = true
rds_engine_version              = "15.4"
rds_database_name               = "finlifedb"
rds_master_username             = "pgadmin"
rds_master_password             = "ChangeMe@12345" # TODO: Change in production and use Secrets Manager
rds_instance_class              = "db.t3.medium"
rds_backup_retention            = 7
rds_multi_az                    = true
rds_publicly_accessible         = false
rds_skip_final_snapshot         = false
rds_enable_cloudwatch_logs      = true
rds_allowed_cidr_blocks         = [] # Add app tier CIDR blocks as needed
rds_enable_enhanced_monitoring  = true
rds_monitoring_interval         = 60