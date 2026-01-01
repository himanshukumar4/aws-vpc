# Aurora Global Database Cluster
resource "aws_rds_global_cluster" "aurora_global" {
  count                     = local.enabled && var.enable_global_database ? 1 : 0
  global_cluster_identifier = "${local.id}-global-cluster"
  engine                    = "aurora-postgresql"
  engine_version            = var.engine_version
}

# RDS DB Subnet Group
resource "aws_db_subnet_group" "aurora_subnet_group" {
  count      = local.enabled ? 1 : 0
  name       = "${local.id}-aurora-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = merge(local.tags, {
    Name = "${local.id}-aurora-subnet-group"
  })
}

# Security Group for Aurora
resource "aws_security_group" "aurora_sg" {
  count       = local.enabled ? 1 : 0
  name        = "${local.id}-aurora-sg"
  description = "Security group for Aurora database"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = concat(var.allowed_cidr_blocks, ["10.0.0.0/16"]) # Allow VPC CIDR by default
    description = "PostgreSQL from VPC"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = merge(local.tags, {
    Name = "${local.id}-aurora-sg"
  })
}

# Enhanced Monitoring Role
resource "aws_iam_role" "aurora_monitoring_role" {
  count = local.enabled && var.enable_enhanced_monitoring ? 1 : 0
  name  = "${local.id}-aurora-monitoring-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      }
    ]
  })

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "aurora_monitoring_policy" {
  count              = local.enabled && var.enable_enhanced_monitoring ? 1 : 0
  role               = aws_iam_role.aurora_monitoring_role[0].name
  policy_arn         = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

# Aurora RDS Cluster (Primary)
resource "aws_rds_cluster" "aurora_cluster" {
  count                            = local.enabled ? 1 : 0
  cluster_identifier               = "${local.id}-aurora-cluster"
  engine                           = "aurora-postgresql"
  engine_version                   = var.engine_version
  database_name                    = var.enable_global_database ? null : var.database_name
  master_username                  = var.enable_global_database ? null : var.master_username
  master_password                  = var.enable_global_database ? null : var.master_password
  global_cluster_identifier        = var.enable_global_database ? aws_rds_global_cluster.aurora_global[0].id : null
  db_subnet_group_name             = aws_db_subnet_group.aurora_subnet_group[0].name
  vpc_security_group_ids           = [aws_security_group.aurora_sg[0].id]
  backup_retention_period          = var.backup_retention_period
  preferred_backup_window          = "03:00-04:00"
  preferred_maintenance_window     = "mon:04:00-mon:05:00"
  skip_final_snapshot              = var.skip_final_snapshot
  final_snapshot_identifier        = var.skip_final_snapshot ? null : "${local.id}-aurora-final-snapshot-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"
  copy_tags_to_snapshot            = true
  delete_automated_backups         = var.skip_final_snapshot ? true : false
  enabled_cloudwatch_logs_exports  = var.enable_cloudwatch_logs ? ["postgresql"] : []
  storage_encrypted                = true
  enable_http_endpoint             = false
  iam_database_authentication_enabled = true

  tags = merge(local.tags, {
    Name = "${local.id}-aurora-cluster"
  })
}

# Aurora Cluster Instances
resource "aws_rds_cluster_instance" "aurora_instances" {
  count              = local.enabled ? 2 : 0
  identifier         = "${local.id}-aurora-instance-${count.index + 1}"
  cluster_identifier = aws_rds_cluster.aurora_cluster[0].id
  instance_class     = var.db_instance_class
  engine              = aws_rds_cluster.aurora_cluster[0].engine
  engine_version      = aws_rds_cluster.aurora_cluster[0].engine_version
  publicly_accessible = var.publicly_accessible

  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  monitoring_interval                   = var.enable_enhanced_monitoring ? var.monitoring_interval : 0
  monitoring_role_arn                   = var.enable_enhanced_monitoring ? aws_iam_role.aurora_monitoring_role[0].arn : null

  tags = merge(local.tags, {
    Name = "${local.id}-aurora-instance-${count.index + 1}"
  })
}

# Secondary DB Subnet Groups (for Global Database)
resource "aws_db_subnet_group" "secondary_subnet_group" {
  for_each   = local.enabled && var.enable_global_database ? toset(var.secondary_regions) : toset([])
  name       = "${local.id}-${each.value}-subnet-group"
  subnet_ids = var.secondary_subnet_ids[each.value]

  tags = merge(local.tags, {
    Name = "${local.id}-${each.value}-subnet-group"
  })
}

# Secondary Security Groups (for Global Database)
resource "aws_security_group" "secondary_sg" {
  for_each    = local.enabled && var.enable_global_database ? toset(var.secondary_regions) : toset([])
  name        = "${local.id}-${each.value}-aurora-sg"
  description = "Security group for Aurora database in ${each.value}"
  vpc_id      = var.secondary_vpc_ids[each.value]

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.aurora_sg[0].id]
    description     = "PostgreSQL from primary region"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = merge(local.tags, {
    Name = "${local.id}-${each.value}-aurora-sg"
  })

  depends_on = [aws_security_group.aurora_sg]
}

# Secondary Aurora Clusters (read-only replicas)
resource "aws_rds_cluster" "secondary_cluster" {
  for_each               = local.enabled && var.enable_global_database ? toset(var.secondary_regions) : toset([])
  cluster_identifier     = "${local.id}-${each.value}-aurora-cluster"
  engine                 = "aurora-postgresql"
  engine_version         = var.engine_version
  global_cluster_identifier = aws_rds_global_cluster.aurora_global[0].id
  db_subnet_group_name   = aws_db_subnet_group.secondary_subnet_group[each.value].name
  vpc_security_group_ids = [aws_security_group.secondary_sg[each.value].id]
  skip_final_snapshot    = var.skip_final_snapshot
  backup_retention_period = var.backup_retention_period
  storage_encrypted      = true

  tags = merge(local.tags, {
    Name = "${local.id}-${each.value}-aurora-cluster"
  })

  depends_on = [aws_rds_cluster.aurora_cluster]
}

# Secondary Aurora Instances (read-only replicas)
resource "aws_rds_cluster_instance" "secondary_instances" {
  for_each = local.enabled && var.enable_global_database ? {
    for region_instance in flatten([
      for region in var.secondary_regions : [
        for i in range(2) : "${region}-${i + 1}"
      ]
    ]) : region_instance => {
      region = split("-", region_instance)[0]
      index  = tonumber(split("-", region_instance)[1]) - 1
    }
  } : {}
  
  identifier         = "${local.id}-${each.value.region}-aurora-instance-${each.value.index + 1}"
  cluster_identifier = aws_rds_cluster.secondary_cluster[each.value.region].id
  instance_class     = var.db_instance_class
  engine              = "aurora-postgresql"
  engine_version      = var.engine_version
  publicly_accessible = var.publicly_accessible

  performance_insights_enabled            = true
  performance_insights_retention_period   = 7

  tags = merge(local.tags, {
    Name = "${local.id}-${each.value.region}-aurora-instance-${each.value.index + 1}"
  })

  depends_on = [aws_rds_cluster.secondary_cluster]
}

# CloudWatch Log Group for Aurora
resource "aws_cloudwatch_log_group" "aurora_log_group" {
  count             = local.enabled && var.enable_cloudwatch_logs ? 1 : 0
  name              = "/aws/rds/${local.id}-aurora"
  retention_in_days = 30

  tags = merge(local.tags, {
    Name = "${local.id}-aurora-logs"
  })
}

# Parameter Group for Aurora
resource "aws_rds_cluster_parameter_group" "aurora_params" {
  count       = local.enabled ? 1 : 0
  name        = "${local.id}-aurora-params"
  family      = "aurora-postgresql15"
  description = "Cluster parameter group for Aurora PostgreSQL"

  parameter {
    name  = "log_statement"
    value = "all"
  }

  parameter {
    name  = "log_min_duration_statement"
    value = "1000"
  }

  tags = merge(local.tags, {
    Name = "${local.id}-aurora-params"
  })
}
