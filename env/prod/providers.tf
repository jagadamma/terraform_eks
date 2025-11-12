provider "aws" {
  region = var.aws_region
}

provider "kubernetes" {
  alias                  = "eks"
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)
  token                  = data.aws_eks_cluster_auth.eks.token
}

provider "helm" {
  alias = "eks"
  kubernetes = {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}
