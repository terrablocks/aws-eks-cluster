output "eks_endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

output "eks_id" {
  value = aws_eks_cluster.eks_cluster.id
}

output "eks_arn" {
  value = aws_eks_cluster.eks_cluster.arn
}

output "eks_ca_data" {
  value = aws_eks_cluster.eks_cluster.certificate_authority.0.data
}

output "eks_sg_id" {
  value = aws_eks_cluster.eks_cluster.vpc_config.0.cluster_security_group_id
}
