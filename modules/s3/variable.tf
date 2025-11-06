variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket"
}

variable "environment" {
  type        = string
  description = "Environment name (e.g., dev, prod)"
}

variable "is_public" {
  type        = bool
  description = "Set to true to make bucket public"
  default     = false
}
