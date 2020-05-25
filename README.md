# Launch an EKS Cluster

This terraform module will deploy the following services:
- EKS Cluster
- Security Group
- IAM Role
- CloudWatch Log Group (Optional)
- KMS Key

# Usage Instructions:
## Variables
| Parameter             | Type    | Description                                                                                                                                                          | Default       | Required |
|-----------------------|---------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------|----------|
| vpc_id                | string  | ID of VPC for launching EKS cluster                                                                                                                                  |               | Y        |
| subnet_ids            | list    | List of subnet ids to be used for launching EKS cluster                                                                                                              |               | Y        |
| kms_deletion_window_in_days          | number  | Days after which KMS key to be deleted                                                                      | 30              | N        |
| kms_enable_key_rotation          | boolean  | Whether to enable automatic key rotation                                                                                                                                                   | false              | N        |
| cluster_name          | string  | Name of EKS cluster                                                                                                                                                  |               | Y        |
| eks_version           | string  | Version to EKS cluster                                                                                                                                               |               | N        |
| enable_private_access | boolean | Whether to enable private access of EKS cluster                                                                                                                      | true          | N        |
| enable_public_access  | boolean | Whether to allow EKS cluster to be accessed publicly                                                                                                                 | false         | N        |
| public_cidrs          | list    | List of CIDRs to be whitelisted if allowing public access                                                                                                            | ["0.0.0.0/0"] | N        |
| eks_log_types         | list    | List of logs to be enabled for EKS cluster. These logs will be stored in CloudWatch Log Group. Valid values: api, audit, authenticator, controllerManager, scheduler |               | N        |

## Outputs
| Parameter           | Type   | Description               |
|---------------------|--------|---------------------------|
| endpoint           | string | Endpoint of EKS cluster            |
| id | string | Name of EKS cluster       |
| arn    | string | ARN of EKS cluster  |
| ca_data           | string | Certificate data of EKS cluster in base64 format            |
| oidc_url           | string | Issuer URL for the OpenID Connect identity provider            |
| sg_id | string | ID of security group created and attached to EKS cluster      |
| role_name | string | Name of IAM role created for EKS cluster      |
| status | string | Status of EKS cluster. Valid values: CREATING, ACTIVE, DELETING, FAILED      |

## Deployment
- `terraform init` - download plugins required to deploy resources
- `terraform plan` - get detailed view of resources that will be created, deleted or replaced
- `terraform apply -auto-approve` - deploy the template without confirmation (non-interactive mode)
- `terraform destroy -auto-approve` - terminate all the resources created using this template without confirmation (non-interactive mode)


## Steps to generate initial kubeconfig
- Run `aws --version` to ensure you have atleast 1.18.17 version installed
- Run `aws eks --region region-code update-kubeconfig --name cluster-name` to generate initial kubeconfig file. Optionally, you can even pass --profile to use custom AWS profile for authentication and --kubeconfig to generate file with custom name and path. **Note:** You need to run this command using the same user identity using which the cluster was created.