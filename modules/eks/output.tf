############################################################
# EKS CLUSTER OUTPUTS
############################################################

output "cluster_name" {
  description = "EKS Cluster Name"
  value       = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  description = "EKS API Server Endpoint"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_ca_certificate" {
  description = "Cluster Certificate Authority Data"
  value       = aws_eks_cluster.main.certificate_authority[0].data
}

############################################################
# OIDC OUTPUT
############################################################

output "oidc_provider_arn" {
  description = "OIDC Provider ARN"
  value       = aws_iam_openid_connect_provider.eks_oidc_provider.arn
}

output "oidc_provider_url" {
  description = "OIDC Provider issuer URL"
  value = replace(
    aws_eks_cluster.main.identity[0].oidc[0].issuer,
    "https://",
    ""
  )
}

############################################################
# IRSA ROLES
############################################################

output "alb_irsa_role_arn" {
  description = "ALB Controller IRSA Role ARN"
  value       = aws_iam_role.alb_irsa_role.arn
}

output "ebs_csi_role_arn" {
  description = "EBS CSI Driver IRSA Role ARN"
  value       = aws_iam_role.ebs_csi_role.arn
}

############################################################
# NODE GROUP OUTPUTS
############################################################

output "node_group_name" {
  description = "Node Group Name"
  value       = aws_eks_node_group.private_nodes.node_group_name
}

output "node_group_role_arn" {
  description = "Node Group IAM Role ARN"
  value       = module.iam.node_group_role_arn
}

############################################################
# ADDON OUTPUTS (SAFE)
############################################################

output "coredns_addon" {
  value = try(aws_eks_addon.coredns.addon_name, null)
}

output "kube_proxy_addon" {
  value = try(aws_eks_addon.kube_proxy.addon_name, null)
}

output "ebs_csi_addon" {
  value = try(aws_eks_addon.aws_ebs_csi_driver.addon_name, null)
}

# VPC CNI removed (installed by AWS automatically)
output "vpc_cni_addon" {
  value = null
}
