variable "vpc_id" {
  type        = string
  description = "ID of VPC for launching EKS cluster"
}

variable "cluster_name" {
  type        = string
  description = "Name for EKS cluster"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet ids to be used for launching EKS cluster"
}

variable "kms_deletion_window_in_days" {
  type        = number
  default     = 30
  description = "Days after which KMS key to be deleted"
}

variable "kms_enable_key_rotation" {
  type        = bool
  default     = false
  description = "Whether to enable automatic key rotation"
}

variable "eks_version" {
  type        = string
  default     = ""
  description = "Version of EKS cluster"
}

variable "enable_private_access" {
  type        = bool
  default     = true
  description = "Whether to enable private access of EKS cluster"
}

variable "enable_public_access" {
  type        = bool
  default     = false
  description = "Whether to allow EKS cluster to be accessed publicly"
}

variable "public_cidrs" {
  type = list(string)
  default = [
    "0.0.0.0/0"
  ]
  description = "List of CIDRs to be whitelisted if allowing public access"
}

variable "eks_log_types" {
  type        = list(string)
  default     = []
  description = "List of logs to be enabled for EKS cluster. These logs will be stored in CloudWatch Log Group. **Valid values:** api, audit, authenticator, controllerManager, scheduler"
}

variable "create_oidc_provider" {
  type        = bool
  default     = false
  description = "Whether to create custom IAM OIDC provider for EKS cluster"
}

variable "security_group_ids" {
  type        = list(string)
  default     = null
  description = "List of security group IDs to associate with EKS cluster"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Map of key value pair to associate with EKS cluster"
}
