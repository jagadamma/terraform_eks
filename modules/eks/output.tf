# modules/eks/output.tf  (new)
output "cluster_name" {
  value = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "cluster_ca_certificate" {
  value = aws_eks_cluster.main.certificate_authority[0].data
}

# Useful if you want to reference OIDC/region from root
output "region" {
  value = var.aws_region
}

output "alb_irsa_role_arn" {
  value = aws_iam_role.alb_irsa_role.arn
  description = "IRSA role ARN for AWS Load Balancer Controller"
}
