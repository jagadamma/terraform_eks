variable "cluster_name" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "desired_capacity" {
  type = number
}

variable "min_capacity" {
  type = number
}

variable "max_capacity" {
  type = number
}

variable "private_subnet_ids" {  # updated name
  type = list(string)
}

variable "aws_region" {
  type = string
}

variable "eks_version" {        # missing in your old version
  type = string
}

variable "ebs_csi_version" {
  description = "Version of the EBS CSI driver addon"
  type        = string
}


