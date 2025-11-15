#########################################################
# TERRAFORM PROVIDERS
#########################################################
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.27.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.12.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0"
    }
  }
}

#########################################################
# AWS PROVIDER
#########################################################
provider "aws" {
  region = var.aws_region
}

#########################################################
# TLS PROVIDER
#########################################################
provider "tls" {}

#########################################################
# EKS AUTH TOKEN
#########################################################
# Must run AFTER EKS Cluster exists
data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_name
}

#########################################################
# KUBERNETES PROVIDER (depends implicitly on data source)
#########################################################
provider "kubernetes" {
  alias                  = "eks"
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)
  token                  = data.aws_eks_cluster_auth.eks.token
}

#########################################################
# HELM PROVIDER
#########################################################
provider "helm" {
  alias = "eks"

  kubernetes = {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}
