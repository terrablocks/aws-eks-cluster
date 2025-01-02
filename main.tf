resource "aws_iam_role" "eks_cluster_role" {
  name                  = "${var.cluster_name}-eks-cluster-role"
  force_detach_policies = true

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      }
    ]
  })

  tags = var.tags
}

locals {
  eks_cluster_role_base_policies = {
    cluster_policy = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  }
  eks_cluster_role_auto_mode_policies = {
    compute_policy    = "arn:aws:iam::aws:policy/AmazonEKSComputePolicy"
    storage_policy    = "arn:aws:iam::aws:policy/AmazonEKSBlockStoragePolicy"
    elb_policy        = "arn:aws:iam::aws:policy/AmazonEKSLoadBalancingPolicy"
    networking_policy = "arn:aws:iam::aws:policy/AmazonEKSNetworkingPolicy"
  }
}

resource "aws_iam_role_policy" "eks_cluster_kms_key" {
  name = "${var.cluster_name}-eks-cluster-kms"
  role = aws_iam_role.eks_cluster_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ListGrants",
          "kms:DescribeKey"
        ]
        Effect   = "Allow"
        Resource = aws_kms_key.eks_key.arn
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policies" {
  for_each   = var.enable_eks_auto_mode ? merge(local.eks_cluster_role_base_policies, local.eks_cluster_role_auto_mode_policies) : local.eks_cluster_role_base_policies
  policy_arn = each.value
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role" "eks_node_role" {
  count                 = var.enable_eks_auto_mode && var.eks_auto_mode_node_role_arn == "" ? 1 : 0
  name                  = "${var.cluster_name}-eks-node-role"
  force_detach_policies = true

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "eks_node_role_minimal_policy" {
  count      = var.enable_eks_auto_mode && var.eks_auto_mode_node_role_arn == "" ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodeMinimalPolicy"
  role       = aws_iam_role.eks_node_role[*].name
}

resource "aws_iam_role_policy_attachment" "eks_node_role_ecr_policy" {
  count      = var.enable_eks_auto_mode && var.eks_auto_mode_node_role_arn == "" ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"
  role       = aws_iam_role.eks_node_role[*].name
}

resource "aws_kms_key" "eks_key" {
  # checkov:skip=CKV_AWS_7: Enabling key rotation is dependant on user
  # checkov:skip=CKV2_AWS_64: Key policy not required
  description             = "Key to encrypt k8s secrets"
  deletion_window_in_days = var.kms_deletion_window_in_days
  enable_key_rotation     = var.kms_enable_key_rotation
  tags                    = var.tags
}

resource "aws_kms_alias" "eks_key_alias" {
  name          = "alias/eks-${var.cluster_name}"
  target_key_id = aws_kms_key.eks_key.key_id
}

resource "aws_eks_cluster" "eks_cluster" {
  # checkov:skip=CKV_AWS_37: Enabling control plane is dependant on user
  # checkov:skip=CKV_AWS_38: Restricting public access to EKS enpoint is dependant on user
  # checkov:skip=CKV_AWS_39: Disabling public access to EKS enpoint is dependant on user
  version  = var.eks_version == "" ? null : var.eks_version
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_private_access = var.enable_private_access
    endpoint_public_access  = var.enable_public_access
    public_access_cidrs     = var.enable_public_access == true ? var.public_cidrs : null
    security_group_ids      = var.security_group_ids
  }

  access_config {
    authentication_mode                         = var.authentication_mode
    bootstrap_cluster_creator_admin_permissions = var.bootstrap_cluster_creator_admin_permissions
  }

  bootstrap_self_managed_addons = var.enable_eks_auto_mode ? false : var.bootstrap_self_managed_addons

  dynamic "compute_config" {
    for_each = var.enable_eks_auto_mode ? [0] : []
    content {
      enabled       = var.enable_eks_auto_mode
      node_pools    = var.eks_auto_mode_node_pools
      node_role_arn = var.enable_eks_auto_mode && var.eks_auto_mode_node_role_arn == "" ? aws_iam_role.eks_node_role[*].arn : var.eks_auto_mode_node_role_arn
    }
  }

  # this needs to be enabled when auto mode is enabled
  kubernetes_network_config {

    dynamic "elastic_load_balancing" {
      for_each = var.enable_eks_auto_mode ? [0] : []
      content {
        enabled = true
      }
    }

    service_ipv4_cidr = var.eks_networking_service_ipv4_cidr
    ip_family         = var.eks_networking_ip_family
  }

  # this needs to be enabled when auto mode is enabled
  dynamic "storage_config" {
    for_each = var.enable_eks_auto_mode ? [0] : []
    content {
      block_storage {
        enabled = true
      }
    }
  }

  enabled_cluster_log_types = var.eks_log_types

  encryption_config {
    provider {
      key_arn = aws_kms_key.eks_key.arn
    }
    resources = ["secrets"]
  }

  upgrade_policy {
    support_type = var.upgrade_policy_support_type
  }

  tags = var.tags

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policies
  ]
}

data "tls_certificate" "eks_oidc" {
  url = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks_oidc" {
  count = var.create_oidc_provider ? 1 : 0
  url   = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = [
    data.tls_certificate.eks_oidc.certificates[0].sha1_fingerprint
  ]

  tags = var.tags
}
