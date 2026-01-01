variable "aws_region" {
  type        = string
  description = "The AWS region to deploy into"
}

variable "target_account_id" {
  type        = string
  description = "The AWS Account ID for safety enforcement"
}

variable "namespace" {
  type        = string
  description = "The organization name (e.g., finlife)"
}

variable "environment" {
  type        = string
  description = "The region identifier used in naming (e.g., us-east-1)"
}

variable "stage" {
  type        = string
  description = "The deployment stage (e.g., dev, prod)"
}

variable "vpc_cidr" {
  type        = string
  description = "Primary CIDR for the VPC"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of AZs for subnet distribution"
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "enable_nat_gateway" {
  type        = bool
  default     = true
  description = "Enable NAT Gateway for private subnet internet access"
}

variable "single_nat_gateway" {
  type        = bool
  default     = false
  description = "Use a single NAT Gateway for all AZs (cost optimization)"
}

# RDS Aurora Variables
variable "enable_rds" {
  type        = bool
  default     = true
  description = "Enable RDS Aurora database deployment"
}

variable "rds_engine_version" {
  type        = string
  default     = "15.4"
  description = "Aurora PostgreSQL engine version"
}

variable "rds_database_name" {
  type        = string
  description = "Name of the default database"
}

variable "rds_master_username" {
  type        = string
  sensitive   = true
  description = "Master username for the database"
}

variable "rds_master_password" {
  type        = string
  sensitive   = true
  description = "Master password for the database"
}

variable "rds_instance_class" {
  type        = string
  default     = "db.t3.medium"
  description = "Instance class for Aurora nodes"
}

variable "rds_backup_retention" {
  type        = number
  default     = 7
  description = "Number of days to retain backups"
}

variable "rds_multi_az" {
  type        = bool
  default     = true
  description = "Enable Multi-AZ deployment"
}

variable "rds_publicly_accessible" {
  type        = bool
  default     = false
  description = "Make the database publicly accessible"
}

variable "rds_skip_final_snapshot" {
  type        = bool
  default     = false
  description = "Skip final snapshot when destroying cluster"
}

variable "rds_enable_cloudwatch_logs" {
  type        = bool
  default     = true
  description = "Enable CloudWatch log exports"
}

variable "rds_allowed_cidr_blocks" {
  type        = list(string)
  default     = []
  description = "CIDR blocks allowed to connect to the database"
}

variable "rds_enable_enhanced_monitoring" {
  type        = bool
  default     = true
  description = "Enable enhanced monitoring"
}

variable "rds_monitoring_interval" {
  type        = number
  default     = 60
  description = "Enhanced monitoring interval in seconds"
}

# RDS Global Database Variables
variable "rds_enable_global_database" {
  type        = bool
  default     = false
  description = "Enable Aurora Global Database for cross-region replication"
}

variable "rds_primary_region" {
  type        = string
  description = "Primary AWS region for the RDS cluster"
}

variable "rds_secondary_regions" {
  type        = list(string)
  default     = []
  description = "List of secondary AWS regions for Global Database read replicas"
}

variable "rds_secondary_vpc_ids" {
  type        = map(string)
  default     = {}
  description = "Map of secondary region to VPC ID (required if enable_global_database=true)"
}

variable "rds_secondary_subnet_ids" {
  type        = map(list(string))
  default     = {}
  description = "Map of secondary region to list of private subnet IDs"
}