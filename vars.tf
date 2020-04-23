variable "vpc_id" {}

variable "cluster_name" {}

variable "subnet_ids" {}

variable "deletion_window_in_days" {
  default = 30
}

variable "enable_key_rotation" {
  default = false
}

variable "eks_version" {
  default = ""
}

variable "enable_private_access" {
  default = true
}

variable "enable_public_access" {
  default = false
}

variable "public_cidrs" {
  type = list
  default = [
    "0.0.0.0/0"
  ]
}

variable "eks_log_types" {
  type    = list
  default = []
}
