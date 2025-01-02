variable "cluster_name" {
  type        = string
  description = "Name for EKS cluster"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet ids to be used for launching EKS cluster"
}

variable "authentication_mode" {
  type        = string
  default     = "API_AND_CONFIG_MAP"
  description = "The authentication mode for the cluster. **Valid values:** CONFIG_MAP, API or API_AND_CONFIG_MAP"
}

variable "bootstrap_cluster_creator_admin_permissions" {
  type        = bool
  default     = false
  description = "Whether or not the cluster creator IAM principal should be assigned cluster admin access during cluster creation"
}

variable "bootstrap_self_managed_addons" {
  type        = bool
  default     = true
  description = "Whether to install default networking add-ons such as aws-cni, kube-proxy, and core-dns during cluster creation. This will be set to false is EKS Auto Mode feature is enabled"
}

variable "enable_eks_auto_mode" {
  type        = bool
  default     = true
  description = "Whether to enable EKS Auto Mode feature. To learn more about it: https://docs.aws.amazon.com/eks/latest/userguide/automode.html"
}

variable "eks_auto_mode_node_pools" {
  type        = set(string)
  default     = ["general-purpose"]
  description = "Configuration for node pools that defines the compute resources for your EKS Auto Mode cluster. **Valid values:** general-purpose and system"
}

variable "eks_auto_mode_node_role_arn" {
  type        = string
  default     = ""
  description = "IAM role to associate with the nodes launched by EKS cluster when Auto Mode is enabled. Leaving this blank when auto mode feature is enabled will create an IAM role with minimal required permissions"
}

variable "eks_networking_service_ipv4_cidr" {
  type        = string
  default     = null
  description = "The private CIDR block to use to assign IPs to pods and services running within the cluster. The CIDR block should not overlap with resources in other networks peered ot connected to your VPC. Leave it to null to let EKS use default CIDR block"
}

variable "eks_networking_ip_family" {
  type        = string
  default     = "ipv4"
  description = "The IP family to use for K8s pods and services. **Valid values:** ipv4 and ipv6. Value can only be specified during cluster creation and changing this values will result in new cluster creation"
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

variable "upgrade_policy_support_type" {
  type        = string
  default     = "STANDARD"
  description = "**Valid values:** EXTENDED, STANDARD. STANDARD will automatically upgrade the cluster reaching end of support and EXTENDED will enable the extended support reaching end of standard support"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Map of key value pair to associate with EKS cluster"
}
