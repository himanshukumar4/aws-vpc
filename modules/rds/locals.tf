locals {
  enabled = var.enabled
  # Identity string: finlife-us-east-1-prod
  id = "${var.namespace}-${var.environment}-${var.stage}"

  tags = {
    Namespace   = var.namespace
    Environment = var.environment
    Stage       = var.stage
    Module      = "RDS"
  }
}
