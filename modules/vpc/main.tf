resource "aws_vpc" "finlife_vpc" {
  count = local.enabled ? 1 : 0

  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(local.tags, {
    Name = "${local.id}-vpc"
  })
}

resource "aws_cloudwatch_log_group" "vpc_flow_log_group" {
  count             = local.enabled ? 1 : 0
  name              = "/aws/vpc/${local.id}-flow-logs"
  retention_in_days = 30
  tags              = local.tags
}

resource "aws_iam_role" "vpc_flow_log_role" {
  count = local.enabled ? 1 : 0
  name  = "${local.id}-vpc-flow-logs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
      }
    ]
  })

  tags = local.tags
}

resource "aws_iam_role_policy" "vpc_flow_log_policy" {
  count = local.enabled ? 1 : 0
  name  = "${local.id}-vpc-flow-logs-policy"
  role  = aws_iam_role.vpc_flow_log_role[0].id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

resource "aws_flow_log" "finlife_vpc_flow_log" {
  count           = local.enabled ? 1 : 0
  iam_role_arn    = aws_iam_role.vpc_flow_log_role[0].arn
  log_destination = aws_cloudwatch_log_group.vpc_flow_log_group[0].arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.finlife_vpc[0].id

  depends_on = [aws_iam_role_policy.vpc_flow_log_policy]
}