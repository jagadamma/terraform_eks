provider "aws" {
  region = var.aws_region
}

module "s3" {
  source      = "../../modules/s3"
  bucket_name = var.bucket_name
  is_public   = var.is_public
  environment = var.environment
}
