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