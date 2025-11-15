############################################
# NODE GROUP
############################################
resource "aws_eks_node_group" "private_nodes" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.cluster_name}-private-nodes"

  node_role_arn   = module.iam.node_group_role_arn
  subnet_ids      = var.private_subnet_ids

  scaling_config {
    desired_size = var.desired_capacity
    max_size     = var.max_capacity
    min_size     = var.min_capacity
  }

  instance_types = [var.instance_type]
  disk_size      = var.disk_size

  depends_on = [
    aws_iam_openid_connect_provider.eks_oidc_provider
  ]
}
