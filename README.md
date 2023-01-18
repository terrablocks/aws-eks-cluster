# Launch an EKS Cluster

![License](https://img.shields.io/github/license/terrablocks/aws-eks-cluster?style=for-the-badge) ![Tests](https://img.shields.io/github/actions/workflow/status/terrablocks/aws-eks-cluster/tests.yml?branch=main&label=Test&style=for-the-badge) ![Checkov](https://img.shields.io/github/actions/workflow/status/terrablocks/aws-eks-cluster/checkov.yml?branch=main&label=Test&style=for-the-badge) ![Commit](https://img.shields.io/github/last-commit/terrablocks/aws-eks-cluster?style=for-the-badge) ![Release](https://img.shields.io/github/v/release/terrablocks/aws-eks-cluster?style=for-the-badge)

This terraform module will deploy the following services:
- EKS Cluster
- Security Group
- IAM Role
- CloudWatch Log Group (Optional)
- KMS Key
- OIDC Provider (Optional)

# Usage Instructions
## Example
```terraform
module "eks_cluster" {
  source = "github.com/terrablocks/aws-eks-cluster.git"

  vpc_id       = "vpc-xxxx"
  subnet_ids   = ["subnet-xxxx", "subnet-xxxx"]
  cluster_name = "eks-cluster"
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| aws | >= 3.37.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vpc_id | ID of VPC for launching EKS cluster | `string` | n/a | yes |
| cluster_name | Name for EKS cluster | `string` | n/a | yes |
| subnet_ids | List of subnet ids to be used for launching EKS cluster | `list(string)` | n/a | yes |
| kms_deletion_window_in_days | Days after which KMS key to be deleted | `number` | `30` | no |
| kms_enable_key_rotation | Whether to enable automatic key rotation | `bool` | `false` | no |
| eks_version | Version of EKS cluster | `string` | `""` | no |
| enable_private_access | Whether to enable private access of EKS cluster | `bool` | `true` | no |
| enable_public_access | Whether to allow EKS cluster to be accessed publicly | `bool` | `false` | no |
| public_cidrs | List of CIDRs to be whitelisted if allowing public access | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| eks_log_types | List of logs to be enabled for EKS cluster. These logs will be stored in CloudWatch Log Group. **Valid values:** api, audit, authenticator, controllerManager, scheduler | `list(string)` | `[]` | no |
| create_oidc_provider | Whether to create custom IAM OIDC provider for EKS cluster | `bool` | `false` | no |
| security_group_ids | List of security group IDs to associate with EKS cluster | `list(string)` | `null` | no |
| tags | Map of key value pair to associate with EKS cluster | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| endpoint | Endpoint of EKS cluster |
| id | Name of EKS cluster |
| arn | ARN of EKS cluster |
| ca_data | Certificate data of EKS cluster in base64 format |
| oidc_url | Issuer URL for the OpenID Connect identity provider |
| sg_id | ID of security group created and attached to EKS cluster |
| role_name | Name of IAM role created for EKS cluster |
| role_arn | ARN of IAM role created for EKS cluster |
| kms_key_arn | ARN of KMS key created for encrypting K8s secrets |
| kms_key_alias | Alias of KMS key created for encrypting K8s secrets |
| status | Status of EKS cluster. Valid values: CREATING, ACTIVE, DELETING, FAILED |
| oidc_provider_arn | ARN of IAM OIDC provider for EKS cluster |

## Steps to generate initial kubeconfig
- Run `aws --version` to ensure you have atleast 1.18.17 version installed
- Run `aws eks --region region-code update-kubeconfig --name cluster-name` to generate initial kubeconfig file. Optionally, you can even pass --profile to use custom AWS profile for authentication and --kubeconfig to generate file with custom name and path. **Note:** You need to run this command using the same user identity using which the cluster was created
