variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "public_subnets" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "is_public" {
  description = "Set to true to make the S3 bucket public"
  type        = bool
}

variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "desired_capacity" {
  description = "Desired capacity for node group"
  type        = number
}

variable "min_capacity" {
  description = "Minimum capacity for node group"
  type        = number
}

variable "max_capacity" {
  description = "Maximum capacity for node group"
  type        = number
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "eks_version" {
  description = "EKS Kubernetes version"
  type        = string
}
