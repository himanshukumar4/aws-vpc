variable "enabled" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from creating any resources"
}

variable "namespace" {
  type = string
}

variable "environment" {
  type = string
}

variable "stage" {
  type = string
}

variable "vpc_cidr" {
  type        = string
  description = "The IPv4 CIDR block for the VPC"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "List of public subnet CIDRs"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "List of private subnet CIDRs"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones in the region"
}

variable "instance_tenancy" {
  type        = string
  default     = "default"
  description = "Allowed values are default or dedicated"
}

variable "enable_nat_gateway" {
  type        = bool
  default     = true
  description = "Enable NAT Gateway for private subnet internet access"
}

variable "single_nat_gateway" {
  type        = bool
  default     = false
  description = "Use a single NAT Gateway for all AZs (cost optimization). If false, one NAT per AZ"
}