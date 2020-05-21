output "endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

output "id" {
  value = aws_eks_cluster.eks_cluster.id
}

output "arn" {
  value = aws_eks_cluster.eks_cluster.arn
}

output "ca_data" {
  value = aws_eks_cluster.eks_cluster.certificate_authority.0.data
}

output "oidc_url" {
  value = aws_eks_cluster.eks_cluster.identity.0.oidc.0.issuer
}

output "sg_id" {
  value = aws_eks_cluster.eks_cluster.vpc_config.0.cluster_security_group_id
}

output "role_name" {
  value = aws_iam_role.eks_role.name
}

output "status" {
  value = aws_eks_cluster.eks_cluster.status
}
