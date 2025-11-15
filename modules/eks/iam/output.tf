output "eks_cluster_role_arn" {
  value = aws_iam_role.eks_cluster_role.arn
}

output "node_group_role_arn" {
  value = aws_iam_role.node_group_role.arn
}

output "eks_cluster_policy_attach" {
  value = aws_iam_role_policy_attachment.eks_cluster_policy_attach.id
}

output "eks_service_policy_attach" {
  value = aws_iam_role_policy_attachment.eks_service_policy_attach.id
}
