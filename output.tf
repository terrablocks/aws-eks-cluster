output "endpoint" {
  value       = aws_eks_cluster.eks_cluster.endpoint
  description = "Endpoint of EKS cluster"
}

output "id" {
  value       = aws_eks_cluster.eks_cluster.id
  description = "Name of EKS cluster"
}

output "arn" {
  value       = aws_eks_cluster.eks_cluster.arn
  description = "ARN of EKS cluster"
}

output "ca_data" {
  value       = aws_eks_cluster.eks_cluster.certificate_authority.0.data
  description = "Certificate data of EKS cluster in base64 format"
}

output "oidc_url" {
  value       = aws_eks_cluster.eks_cluster.identity.0.oidc.0.issuer
  description = "Issuer URL for the OpenID Connect identity provider"
}

output "sg_id" {
  value       = aws_eks_cluster.eks_cluster.vpc_config.0.cluster_security_group_id
  description = "ID of security group created and attached to EKS cluster"
}

output "role_name" {
  value       = aws_iam_role.eks_role.name
  description = "Name of IAM role created for EKS cluster"
}

output "status" {
  value       = aws_eks_cluster.eks_cluster.status
  description = "Status of EKS cluster. Valid values: CREATING, ACTIVE, DELETING, FAILED"
}

output "oidc_provider_arn" {
  value       = var.create_oidc_provider ? join(",", aws_iam_openid_connect_provider.eks_oidc.*.arn) : null
  description = "ARN of IAM OIDC provider for EKS cluster"
}
