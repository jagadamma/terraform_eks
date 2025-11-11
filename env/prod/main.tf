provider "aws" {
  region = var.aws_region
}

terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.12.0"
    }
  }
}
module "vpc" {
  source             = "../../modules/vpc"
  aws_region         = var.aws_region
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  cluster_name       = var.cluster_name   

}


module "eks" {
  source            = "../../modules/eks"
  cluster_name      = var.cluster_name
  eks_version       = var.eks_version
  desired_capacity  = var.desired_capacity
  min_capacity      = var.min_capacity
  max_capacity      = var.max_capacity
  instance_type     = var.instance_type
  private_subnet_ids = module.vpc.private_subnet_ids
  aws_region         = var.aws_region
  ebs_csi_version = var.ebs_csi_version

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }
}


resource "helm_release" "kube_prometheus_stack" {
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = "monitoring"
  version    = "66.6.0"

  create_namespace = true

  values = [
    file("${path.module}/prometheus-values.yaml")
  ]

  depends_on = [
    module.eks  
  ]
}


module "s3" {
  source      = "../../modules/s3"
  bucket_name = var.bucket_name
  is_public   = var.is_public
  environment = var.environment
}
