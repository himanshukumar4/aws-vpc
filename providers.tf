provider "aws" {
  region                      = var.aws_region
  skip_credentials_validation = true # For local validation without AWS credentials
  skip_requesting_account_id  = true

  default_tags {
    tags = {
      Namespace   = var.namespace
      Environment = var.environment
      Stage       = var.stage
      ManagedBy   = "Terraform"
    }
  }
}