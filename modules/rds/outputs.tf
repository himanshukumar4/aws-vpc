output "cluster_id" {
  value       = try(aws_rds_cluster.aurora_cluster[0].id, "")
  description = "Aurora cluster ID"
}

output "cluster_endpoint" {
  value       = try(aws_rds_cluster.aurora_cluster[0].endpoint, "")
  description = "Aurora cluster endpoint (write endpoint)"
}

output "cluster_reader_endpoint" {
  value       = try(aws_rds_cluster.aurora_cluster[0].reader_endpoint, "")
  description = "Aurora cluster reader endpoint"
}

output "global_cluster_id" {
  value       = try(aws_rds_global_cluster.aurora_global[0].id, "")
  description = "Aurora Global Database cluster ID"
}

output "global_cluster_arn" {
  value       = try(aws_rds_global_cluster.aurora_global[0].arn, "")
  description = "Aurora Global Database cluster ARN"
}

output "secondary_cluster_ids" {
  value       = { for region, cluster in aws_rds_cluster.secondary_cluster : region => cluster.id }
  description = "Map of secondary region to cluster ID"
}

output "secondary_cluster_endpoints" {
  value       = { for region, cluster in aws_rds_cluster.secondary_cluster : region => cluster.endpoint }
  description = "Map of secondary region to reader endpoint (read-only)"
}

output "database_name" {
  value       = try(aws_rds_cluster.aurora_cluster[0].database_name, "")
  description = "Name of the default database"
}

output "master_username" {
  value       = try(aws_rds_cluster.aurora_cluster[0].master_username, "")
  description = "Master username"
}

output "instance_endpoints" {
  value       = try(aws_rds_cluster_instance.aurora_instances[*].endpoint, [])
  description = "Endpoints for individual cluster instances"
}

output "security_group_id" {
  value       = try(aws_security_group.aurora_sg[0].id, "")
  description = "Security group ID for Aurora database"
}

output "db_subnet_group_name" {
  value       = try(aws_db_subnet_group.aurora_subnet_group[0].name, "")
  description = "DB subnet group name"
}

output "port" {
  value       = 5432
  description = "Aurora PostgreSQL port"
}

output "arn" {
  value       = try(aws_rds_cluster.aurora_cluster[0].arn, "")
  description = "Aurora cluster ARN"
}
