resource "aws_iam_role" "eks_role" {
  name = "${var.cluster_name}-eks-cluster-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

  tags = var.tags
}

resource "aws_iam_role_policy" "eks_cluster_kms_key" {
  name = "${var.cluster_name}-eks-cluster-kms"
  role = aws_iam_role.eks_role.id
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

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_role.name
}

resource "aws_iam_role_policy_attachment" "eks_service_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_role.name
}

resource "aws_kms_key" "eks_key" {
  # checkov:skip=CKV_AWS_7: Enabling key rotation is dependant on user
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
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_private_access = var.enable_private_access
    endpoint_public_access  = var.enable_public_access
    public_access_cidrs     = var.enable_public_access == true ? var.public_cidrs : null
    security_group_ids      = var.security_group_ids
  }

  enabled_cluster_log_types = var.eks_log_types

  encryption_config {
    provider {
      key_arn = aws_kms_key.eks_key.arn
    }
    resources = ["secrets"]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_service_policy,
  ]

  tags = var.tags
}

data "tls_certificate" "eks_oidc" {
  url = aws_eks_cluster.eks_cluster.identity.0.oidc.0.issuer
}

resource "aws_iam_openid_connect_provider" "eks_oidc" {
  count = var.create_oidc_provider ? 1 : 0
  url   = aws_eks_cluster.eks_cluster.identity.0.oidc.0.issuer

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = [
    data.tls_certificate.eks_oidc.certificates.0.sha1_fingerprint
  ]

  tags = var.tags
}
