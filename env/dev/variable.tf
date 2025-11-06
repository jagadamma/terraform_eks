variable "aws_region" {
  description = "Name of the S3 bucket region"
  type        = string
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "is_public" {
  description = "Set to true to make the S3 bucket public"
  type        = bool
}

variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}
