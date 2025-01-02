module "eks_cluster" {
  source = "github.com/terrablocks/aws-eks-cluster.git?ref=" # Always use `ref` to point module to a specific version or hash

  cluster_name = "eks-cluster"
  subnet_ids   = ["subnet-xxxx", "subnet-xxxx"]
}
