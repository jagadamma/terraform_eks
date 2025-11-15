############################################
# EKS CLUSTER
############################################
resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  version  = var.eks_version
  role_arn = module.iam.eks_cluster_role_arn

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  depends_on = [
    module.iam.eks_cluster_policy_attach,
    module.iam.eks_service_policy_attach
  ]
}

############################################
# OIDC PROVIDER (REQUIRED FOR IRSA)
############################################
data "tls_certificate" "eks_oidc_thumbprint" {
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks_oidc_provider" {
  url             = aws_eks_cluster.main.identity[0].oidc[0].issuer
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks_oidc_thumbprint.certificates[0].sha1_fingerprint]
}

############################################
# ALB IRSA ASSUME ROLE POLICY
############################################
data "aws_iam_policy_document" "alb_irsa_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.eks_oidc_provider.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_eks_cluster.main.identity[0].oidc[0].issuer, "https://", "")}:sub"
      values   = [
        "system:serviceaccount:kube-system:aws-load-balancer-controller"
      ]
    }
  }
}

############################################
# EBS CSI IRSA ASSUME ROLE POLICY
############################################
data "aws_iam_policy_document" "ebs_csi_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.eks_oidc_provider.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_eks_cluster.main.identity[0].oidc[0].issuer, "https://", "")}:sub"
      values   = [
        "system:serviceaccount:kube-system:ebs-csi-controller-sa"
      ]
    }
  }
}

############################################
# ALB INLINE POLICY (JSON FILE)
############################################
resource "aws_iam_policy" "alb_controller_policy" {
  name   = "${var.cluster_name}-alb-controller-policy"
  policy = file("${path.module}/iam/alb-controller-policy.json")
}

############################################
# ALB IRSA ROLE
############################################
resource "aws_iam_role" "alb_irsa_role" {
  name               = "${var.cluster_name}-alb-irsa-role"
  assume_role_policy = data.aws_iam_policy_document.alb_irsa_assume_role.json
}

resource "aws_iam_role_policy_attachment" "alb_irsa_attach" {
  role       = aws_iam_role.alb_irsa_role.name
  policy_arn = aws_iam_policy.alb_controller_policy.arn
}

############################################
# EBS CSI IRSA ROLE
############################################
resource "aws_iam_role" "ebs_csi_role" {
  name               = "${var.cluster_name}-ebs-csi-role"
  assume_role_policy = data.aws_iam_policy_document.ebs_csi_assume_role.json
}

resource "aws_iam_role_policy_attachment" "ebs_csi_attach" {
  role       = aws_iam_role.ebs_csi_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}
