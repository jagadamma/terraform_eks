aws_region         = "us-east-1"
vpc_cidr           = "10.1.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b"]
public_subnets     = ["10.1.1.0/24", "10.1.2.0/24"]
private_subnets    = ["10.1.3.0/24", "10.1.4.0/24"]
cluster_name       = "eks-cluater"
eks_version        = "1.33"
ebs_csi_version    = "v1.52.1-eksbuild.1"


desired_capacity   = 2
min_capacity       = 1
max_capacity       = 2
instance_type      = "t3.medium"
bucket_name = "10-11-2026"
is_public   = true
environment = "prod"
