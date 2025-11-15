#########################################################
# VPC MODULE
#########################################################
module "vpc" {
  source             = "../../modules/vpc"
  aws_region         = var.aws_region
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  cluster_name       = var.cluster_name
}

#########################################################
# EKS MODULE
#########################################################
module "eks" {
  source             = "../../modules/eks"

  cluster_name       = var.cluster_name
  aws_region         = var.aws_region
  eks_version        = var.eks_version

  desired_capacity   = var.desired_capacity
  min_capacity       = var.min_capacity
  max_capacity       = var.max_capacity

  instance_type      = var.instance_type
  private_subnet_ids = module.vpc.private_subnet_ids

  ebs_csi_version    = var.ebs_csi_version
  disk_size          = var.disk_size
}

#########################################################
# WAIT FOR EKS API SERVER (IMPORTANT)
#########################################################
resource "null_resource" "wait_for_eks" {
  depends_on = [module.eks]

  provisioner "local-exec" {
    command = <<EOF
echo "Waiting 120 seconds for EKS API endpoint to stabilize..."
sleep 120
EOF
  }
}


#########################################################
# METRICS SERVER
#########################################################
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

  set = [{
    name  = "args"
    value = "{--kubelet-insecure-tls,--kubelet-preferred-address-types=InternalIP}"
  }]

   depends_on = [
    module.eks,
    null_resource.wait_for_eks
  ]
}

#########################################################
# AWS LOAD BALANCER CONTROLLER
#########################################################
resource "helm_release" "aws_load_balancer_controller" {
  provider         = helm.eks
  name             = "aws-load-balancer-controller"
  repository       = "https://aws.github.io/eks-charts"
  chart            = "aws-load-balancer-controller"
  namespace        = "kube-system"
  version          = "1.8.1"
  create_namespace = false

  set = [
    { name = "clusterName", value = module.eks.cluster_name },
    { name = "region",      value = var.aws_region },
    { name = "vpcId",       value = module.vpc.vpc_id },
    {
      name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = module.eks.alb_irsa_role_arn
    }
  ]

   depends_on = [
    module.eks,
    null_resource.wait_for_eks
  ]
}

#########################################################
# PROMETHEUS STACK
#########################################################
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
  depends_on = [
    module.eks,
    null_resource.wait_for_eks,
    helm_release.aws_load_balancer_controller
  ]

}

#########################################################
# S3 MODULE
#########################################################
module "s3" {
  source      = "../../modules/s3"
  bucket_name = var.bucket_name
  is_public   = var.is_public
  environment = var.environment
}
