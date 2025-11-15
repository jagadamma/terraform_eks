############################################################
# AWS & REGION
############################################################
aws_region     = "us-east-2"
cluster_name   = "eks-cluster"

############################################################
# VPC CONFIGURATION
############################################################
vpc_cidr = "10.0.0.0/16"

availability_zones = [
  "us-east-2a",
  "us-east-2b",
  "us-east-2c"
]

public_subnets = [
  "10.0.1.0/24",
  "10.0.2.0/24",
  "10.0.3.0/24"
]

private_subnets = [
  "10.0.10.0/24",
  "10.0.11.0/24",
  "10.0.12.0/24"
]

############################################################
# EKS CONFIGURATION
############################################################
eks_version = "1.33"       # set based on your requirement

instance_type    = "t3.medium"
desired_capacity = 2
min_capacity     = 1
max_capacity     = 3

disk_size = 20             # 30GB EBS for worker nodes

############################################################
# ADDONS
############################################################
ebs_csi_version = "v1.52.1-eksbuild.1"

bucket_name     = "prod-app-storage-abilash"
environment     = "prod"
is_public       = false
