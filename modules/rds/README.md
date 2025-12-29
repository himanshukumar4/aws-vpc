# Aurora RDS Module

This module creates an Amazon Aurora PostgreSQL cluster with the following features:

## Features

- **Aurora PostgreSQL Cluster**: Multi-AZ deployment with automatic failover
- **Enhanced Monitoring**: Performance Insights and RDS Enhanced Monitoring
- **Security**: 
  - Encryption at rest (AWS KMS managed keys)
  - IAM database authentication enabled
  - Security group with restricted ingress
- **Backup & Recovery**:
  - Automated backups with configurable retention
  - Final snapshot capability
- **Observability**:
  - CloudWatch log exports (PostgreSQL logs)
  - Performance Insights
  - Enhanced monitoring

## Module Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `enabled` | Enable/disable module | `bool` | `true` |
| `namespace` | Organization name | `string` | - |
| `environment` | Region identifier | `string` | - |
| `stage` | Deployment stage (dev/prod) | `string` | - |
| `vpc_id` | VPC ID for deployment | `string` | - |
| `private_subnet_ids` | Private subnet IDs for DB subnet group | `list(string)` | - |
| `engine_version` | Aurora PostgreSQL version | `string` | `15.4` |
| `database_name` | Default database name | `string` | - |
| `master_username` | Master database user | `string` | - |
| `master_password` | Master database password | `string` | - |
| `db_instance_class` | RDS instance type | `string` | `db.t3.medium` |
| `backup_retention_period` | Backup retention days | `number` | `7` |
| `multi_az` | Enable Multi-AZ | `bool` | `true` |
| `publicly_accessible` | Public accessibility | `bool` | `false` |
| `skip_final_snapshot` | Skip final snapshot | `bool` | `false` |
| `enable_cloudwatch_logs` | Enable CloudWatch logs | `bool` | `true` |
| `allowed_cidr_blocks` | Additional allowed CIDR blocks | `list(string)` | `[]` |
| `enable_enhanced_monitoring` | Enable enhanced monitoring | `bool` | `true` |
| `monitoring_interval` | Monitoring interval (seconds) | `number` | `60` |

## Module Outputs

| Name | Description |
|------|-------------|
| `cluster_id` | Aurora cluster identifier |
| `cluster_endpoint` | Write endpoint |
| `cluster_reader_endpoint` | Read-only endpoint |
| `database_name` | Database name |
| `master_username` | Master username |
| `instance_endpoints` | Individual instance endpoints |
| `security_group_id` | DB security group ID |
| `db_subnet_group_name` | DB subnet group name |
| `port` | Database port (5432) |
| `arn` | Cluster ARN |

## Cluster Configuration

The module creates:
- **1 Aurora Cluster** with PostgreSQL engine
- **2 Aurora Instances** (primary + replica for automatic failover)
- **DB Subnet Group** across specified private subnets
- **Security Group** allowing PostgreSQL (5432) from VPC CIDR
- **IAM Role** for enhanced monitoring
- **CloudWatch Log Group** for PostgreSQL logs
- **Parameter Group** with optimized PostgreSQL settings

## Security Best Practices

1. **Password Management**: Use AWS Secrets Manager for storing/rotating passwords
2. **Network Access**: Restrict to private subnets only in production
3. **Encryption**: All data encrypted at rest and in transit
4. **IAM Auth**: Enable IAM database authentication for additional security
5. **Backups**: Enable final snapshot in production

## Cost Optimization

- Use `db.t3.medium` for development/testing
- Set `single_nat_gateway = true` for NAT costs in dev
- Configure `backup_retention_period = 7` (default) - increase for production
- Use `skip_final_snapshot = true` only in non-production when appropriate

## Connection String

PostgreSQL connection string format:
```
postgresql://[user]:[password]@[endpoint]:5432/[database]
```

Example:
```
postgresql://pgadmin:YourPassword@finlife-us-east-1-dev-aurora-cluster.xxxxx.us-east-1.rds.amazonaws.com:5432/finlifedb
```

## Next Steps

1. Update `rds_master_password` in `dev.tfvars`
2. Configure `rds_allowed_cidr_blocks` for application tier access
3. Plan and apply Terraform:
   ```bash
   terraform plan
   terraform apply
   ```
4. Store database credentials in AWS Secrets Manager
5. Configure application connection pooling (e.g., PgBouncer)
