############################################################
# ENV / PROD VARIABLES
############################################################

variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "availability_zones" {
  description = "List of AZs for subnets"
  type        = list(string)
}

variable "public_subnets" {
  description = "List of public subnet CIDRs"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnet CIDRs"
  type        = list(string)
}

variable "eks_version" {
  description = "EKS Kubernetes version"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for node group"
  type        = string
}

variable "desired_capacity" {
  description = "Desired number of worker nodes"
  type        = number
}

variable "min_capacity" {
  description = "Minimum number of worker nodes"
  type        = number
}

variable "max_capacity" {
  description = "Maximum number of worker nodes"
  type        = number
}

variable "disk_size" {
  description = "EBS disk size for worker nodes (GB)"
  type        = number
}

variable "ebs_csi_version" {
  description = "Version of the EBS CSI Driver addon"
  type        = string
}

###############
# S3 MODULE
###############
variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
}

variable "is_public" {
  description = "Make S3 bucket public? true/false"
  type        = bool
}

variable "environment" {
  description = "Environment name (dev/prod)"
  type        = string
}
