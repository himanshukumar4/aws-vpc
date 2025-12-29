terraform {
  backend "local" {
    path = "terraform.tfstate"
  }

  # Uncomment below for S3 remote backend (production recommended)
  # backend "s3" {
  #   bucket         = "finlife-terraform-state"
  #   key            = "vpc/terraform.tfstate"
  #   region         = "us-east-1"
  #   encrypt        = true
  #   dynamodb_table = "terraform-locks"
  # }

  # Uncomment below for Terraform Cloud backend
  # cloud {
  #   organization = "finlife-org"
  #   workspaces {
  #     name = "vpc-dev"
  #   }
  # }
}
