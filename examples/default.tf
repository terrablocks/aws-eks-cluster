module "eks_cluster" {
  source = "github.com/terrablocks/aws-eks-cluster.git?ref=" # Always use `ref` to point module to a specific version or hash

  subnet_ids   = ["subnet-xxxx", "subnet-xxxx"]
  cluster_name = "eks-cluster"
}
