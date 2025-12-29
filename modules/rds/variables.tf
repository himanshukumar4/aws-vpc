variable "enabled" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from creating any resources"
}

variable "namespace" {
  type        = string
  description = "The organization name"
}

variable "environment" {
  type        = string
  description = "The region identifier used in naming"
}

variable "stage" {
  type        = string
  description = "The deployment stage"
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID where RDS will be deployed"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for DB subnet group"
}

variable "engine_version" {
  type        = string
  default     = "15.4"
  description = "Aurora PostgreSQL engine version"
}

variable "database_name" {
  type        = string
  description = "Name of the default database"
}

variable "master_username" {
  type        = string
  description = "Master username for the database"
  sensitive   = true
}

variable "master_password" {
  type        = string
  description = "Master password for the database"
  sensitive   = true
}

variable "db_instance_class" {
  type        = string
  default     = "db.t3.medium"
  description = "Instance class for Aurora nodes"
}

variable "allocated_storage" {
  type        = number
  default     = 20
  description = "Allocated storage in GB (not used for Aurora, but kept for consistency)"
}

variable "backup_retention_period" {
  type        = number
  default     = 7
  description = "Number of days to retain backups"
}

variable "multi_az" {
  type        = bool
  default     = true
  description = "Enable Multi-AZ deployment"
}

variable "publicly_accessible" {
  type        = bool
  default     = false
  description = "Make the database publicly accessible"
}

variable "skip_final_snapshot" {
  type        = bool
  default     = false
  description = "Skip final snapshot when destroying cluster"
}

variable "enable_cloudwatch_logs" {
  type        = bool
  default     = true
  description = "Enable CloudWatch log exports"
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  default     = []
  description = "CIDR blocks allowed to connect to the database"
}

variable "enable_enhanced_monitoring" {
  type        = bool
  default     = true
  description = "Enable enhanced monitoring"
}

variable "monitoring_interval" {
  type        = number
  default     = 60
  description = "Enhanced monitoring interval in seconds"
}
