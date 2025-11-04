# AWS Region
variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
}

# VPC CIDR
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

# Public Subnets
variable "public_subnets" {
  description = "List of public subnet CIDRs"
  type        = list(string)
}

# Private Subnets
variable "private_subnets" {
  description = "List of private subnet CIDRs"
  type        = list(string)
}

# Availability Zones
variable "availability_zones" {
  description = "List of availability zones to distribute subnets across"
  type        = list(string)
}
