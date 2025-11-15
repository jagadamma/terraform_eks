############################################
# IAM MODULE CALL
############################################
module "iam" {
  source       = "./iam"
  cluster_name = var.cluster_name
  aws_region   = var.aws_region
}
