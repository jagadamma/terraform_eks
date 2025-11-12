terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.12.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.27.0"
    }
  }
}

# VPC Module
module "vpc" {
  source             = "../../modules/vpc"
  aws_region         = var.aws_region
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  cluster_name       = var.cluster_name
}

# EKS Module
module "eks" {
  source             = "../../modules/eks"
  cluster_name       = var.cluster_name
  eks_version        = var.eks_version
  desired_capacity   = var.desired_capacity
  min_capacity       = var.min_capacity
  max_capacity       = var.max_capacity
  instance_type      = var.instance_type
  private_subnet_ids = module.vpc.private_subnet_ids
  aws_region         = var.aws_region
  ebs_csi_version    = var.ebs_csi_version
}

#######################################
# Metrics Server
#######################################
resource "helm_release" "metrics_server" {
  provider         = helm.eks
  name             = "metrics-server"
  repository       = "https://kubernetes-sigs.github.io/metrics-server/"
  chart            = "metrics-server"
  namespace        = "kube-system"
  version          = "3.12.1"
  create_namespace = false
  wait             = true
  timeout          = 300

  set = [
    {
      name  = "args"
      value = "{--kubelet-insecure-tls,--kubelet-preferred-address-types=InternalIP}"
    }
  ]

  depends_on = [module.eks]
}

#######################################
# AWS Load Balancer Controller
#######################################
resource "helm_release" "aws_load_balancer_controller" {
  provider         = helm.eks
  name             = "aws-load-balancer-controller"
  repository       = "https://aws.github.io/eks-charts"
  chart            = "aws-load-balancer-controller"
  namespace        = "kube-system"
  version          = "1.8.1"
  create_namespace = false

  set = [
    {
      name  = "clusterName"
      value = module.eks.cluster_name
    },
    {
      name  = "region"
      value = var.aws_region
    },
    {
      name  = "vpcId"
      value = module.vpc.vpc_id
    }
  ]

  depends_on = [module.eks]
}

#######################################
# S3 Module
#######################################
module "s3" {
  source      = "../../modules/s3"
  bucket_name = var.bucket_name
  is_public   = var.is_public
  environment = var.environment
}

#######################################
# Prometheus Stack
#######################################
resource "helm_release" "kube_prometheus_stack" {
  provider         = helm.eks
  name             = "kube-prometheus-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = "monitoring"
  version          = "66.6.0"
  create_namespace = true

  values = [
    file("${path.module}/prometheus-values.yaml")
  ]

  depends_on = [module.eks]
}
