<!-- BEGIN_TF_DOCS -->
# Launch an EKS Cluster

![License](https://img.shields.io/github/license/terrablocks/aws-eks-cluster?style=for-the-badge) ![Plan](https://img.shields.io/github/actions/workflow/status/terrablocks/aws-eks-cluster/tf-plan.yml?branch=main&label=Plan&style=for-the-badge) ![Checkov](https://img.shields.io/github/actions/workflow/status/terrablocks/aws-eks-cluster/checkov.yml?branch=main&label=Checkov&style=for-the-badge) ![Commit](https://img.shields.io/github/last-commit/terrablocks/aws-eks-cluster?style=for-the-badge) ![Release](https://img.shields.io/github/v/release/terrablocks/aws-eks-cluster?style=for-the-badge)

This terraform module will deploy the following services:
- EKS Cluster
- Security Group
- IAM Role
- CloudWatch Log Group (Optional)
- KMS Key
- OIDC Provider (Optional)

# Usage Instructions
## Example
```hcl
module "eks_cluster" {
  source = "github.com/terrablocks/aws-eks-cluster.git?ref=" # Always use `ref` to point module to a specific version or hash

  cluster_name = "eks-cluster"
  subnet_ids   = ["subnet-xxxx", "subnet-xxxx"]
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.8.0 |
| aws | >= 5.0.0 |
| tls | 4.0.6 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| authentication_mode | The authentication mode for the cluster. **Valid values:** CONFIG_MAP, API or API_AND_CONFIG_MAP | `string` | `"API_AND_CONFIG_MAP"` | no |
| bootstrap_cluster_creator_admin_permissions | Whether or not the cluster creator IAM principal should be assigned cluster admin access during cluster creation | `bool` | `false` | no |
| bootstrap_self_managed_addons | Whether to install default networking add-ons such as aws-cni, kube-proxy, and core-dns during cluster creation. This will be set to false is EKS Auto Mode feature is enabled | `bool` | `true` | no |
| cluster_name | Name for EKS cluster | `string` | n/a | yes |
| create_oidc_provider | Whether to create custom IAM OIDC provider for EKS cluster | `bool` | `false` | no |
| eks_auto_mode_node_pools | Configuration for node pools that defines the compute resources for your EKS Auto Mode cluster. **Valid values:** general-purpose and system | `set(string)` | ```[ "general-purpose" ]``` | no |
| eks_auto_mode_node_role_arn | IAM role to associate with the nodes launched by EKS cluster when Auto Mode is enabled. Leaving this blank when auto mode feature is enabled will create an IAM role with minimal required permissions | `string` | `""` | no |
| eks_log_types | List of logs to be enabled for EKS cluster. These logs will be stored in CloudWatch Log Group. **Valid values:** api, audit, authenticator, controllerManager, scheduler | `list(string)` | `[]` | no |
| eks_networking_ip_family | The IP family to use for K8s pods and services. **Valid values:** ipv4 and ipv6. Value can only be specified during cluster creation and changing this values will result in new cluster creation | `string` | `"ipv4"` | no |
| eks_networking_service_ipv4_cidr | The private CIDR block to use to assign IPs to pods and services running within the cluster. The CIDR block should not overlap with resources in other networks peered ot connected to your VPC. Leave it to null to let EKS use default CIDR block | `string` | `null` | no |
| eks_version | Version of EKS cluster | `string` | `""` | no |
| enable_eks_auto_mode | Whether to enable EKS Auto Mode feature. To learn more about it: https://docs.aws.amazon.com/eks/latest/userguide/automode.html | `bool` | `true` | no |
| enable_private_access | Whether to enable private access of EKS cluster | `bool` | `true` | no |
| enable_public_access | Whether to allow EKS cluster to be accessed publicly | `bool` | `false` | no |
| kms_deletion_window_in_days | Days after which KMS key to be deleted | `number` | `30` | no |
| kms_enable_key_rotation | Whether to enable automatic key rotation | `bool` | `false` | no |
| public_cidrs | List of CIDRs to be whitelisted if allowing public access | `list(string)` | ```[ "0.0.0.0/0" ]``` | no |
| security_group_ids | List of security group IDs to associate with EKS cluster | `list(string)` | `null` | no |
| subnet_ids | List of subnet ids to be used for launching EKS cluster | `list(string)` | n/a | yes |
| tags | Map of key value pair to associate with EKS cluster | `map(string)` | `{}` | no |
| upgrade_policy_support_type | **Valid values:** EXTENDED, STANDARD. STANDARD will automatically upgrade the cluster reaching end of support and EXTENDED will enable the extended support reaching end of standard support | `string` | `"STANDARD"` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | ARN of EKS cluster |
| ca_data | Certificate data of EKS cluster in base64 format |
| endpoint | Endpoint of EKS cluster |
| id | Name of EKS cluster |
| kms_key_alias | Alias of KMS key created for encrypting K8s secrets |
| kms_key_arn | ARN of KMS key created for encrypting K8s secrets |
| oidc_provider_arn | ARN of IAM OIDC provider for EKS cluster |
| oidc_url | Issuer URL for the OpenID Connect identity provider |
| role_arn | ARN of IAM role created for EKS cluster |
| role_name | Name of IAM role created for EKS cluster |
| sg_id | ID of security group created and attached to EKS cluster |
| status | Status of EKS cluster. Valid values: CREATING, ACTIVE, DELETING, FAILED |

## Steps to generate initial kubeconfig
- Run `aws --version` to ensure you have atleast 1.18.17 version installed
- Run `aws eks --region region-code update-kubeconfig --name cluster-name` to generate initial kubeconfig file. Optionally, you can even pass --profile to use custom AWS profile for authentication and --kubeconfig to generate file with custom name and path. **Note:** You need to run this command using the same user identity using which the cluster was created
<!-- END_TF_DOCS -->
