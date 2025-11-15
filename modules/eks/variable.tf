variable "cluster_name" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "eks_version" {
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

variable "instance_type" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "ebs_csi_version" {
  type = string
}

variable "disk_size" {
  type = number
}
