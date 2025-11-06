aws_region         = "ap-south-1"
vpc_cidr           = "10.1.0.0/16"
availability_zones = ["ap-south-1a", "ap-south-1b"]
public_subnets     = ["10.1.1.0/24", "10.1.2.0/24"]
private_subnets    = ["10.1.3.0/24", "10.1.4.0/24"]
cluster_name       = "eks-cluater"
eks_version        = "1.33"

desired_capacity   = 2
min_capacity       = 1
max_capacity       = 2
instance_type      = "t3.medium"
bucket_name = "5-11-2025"
is_public   = true
environment = "prod"
