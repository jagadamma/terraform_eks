############################################
# CoreDNS
############################################
resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.main.name
  addon_name   = "coredns"

  depends_on = [
    aws_eks_node_group.private_nodes
  ]
}

############################################
# kube-proxy
############################################
resource "aws_eks_addon" "kube_proxy" {
  cluster_name = aws_eks_cluster.main.name
  addon_name   = "kube-proxy"

  depends_on = [
    aws_eks_node_group.private_nodes
  ]
}

############################################
# VPC CNI
############################################
#resource "aws_eks_addon" "vpc_cni" {
#  cluster_name = aws_eks_cluster.main.name
#  addon_name   = "vpc-cni"
#
#  depends_on = [
#    aws_eks_node_group.private_nodes
#  ]
#}

############################################
# EBS CSI DRIVER (uses IRSA role created in eks.tf)
############################################
resource "aws_eks_addon" "aws_ebs_csi_driver" {
  cluster_name             = aws_eks_cluster.main.name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = var.ebs_csi_version

  service_account_role_arn = aws_iam_role.ebs_csi_role.arn

  depends_on = [
    aws_iam_role_policy_attachment.ebs_csi_attach,
    aws_eks_node_group.private_nodes
  ]
}
