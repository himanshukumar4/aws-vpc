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