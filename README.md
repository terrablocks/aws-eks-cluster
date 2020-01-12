# Launch an EKS Cluster

This terraform module will deploy the following services:
- EKS Cluster
- Security Group
- IAM Role
- CloudWatch Log Group (Optional)

# Usage Instructions:
## Variables
| Parameter             | Type    | Description                                                                                                                                                          | Default       | Required |
|-----------------------|---------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------|----------|
| vpc_id                | string  | ID of VPC for launching EKS cluster                                                                                                                                  |               | Y        |
| subnet_ids            | list    | List of subnet ids to be used for launching EKS cluster                                                                                                              |               | Y        |
| cluster_name          | string  | Name of EKS cluster                                                                                                                                                  |               | Y        |
| eks_version           | string  | Version to EKS cluster                                                                                                                                               |               | N        |
| enable_private_access | boolean | Whether to enable private access of EKS cluster                                                                                                                      | true          | N        |
| enable_public_access  | boolean | Whether to allow EKS cluster to be accessed publicly                                                                                                                 | false         | N        |
| public_cidrs          | list    | List of CIDRs to be whitelisted if allowing public access                                                                                                            | ["0.0.0.0/0"] | N        |
| eks_log_types         | list    | List of logs to be enabled for EKS cluster. These logs will be stored in CloudWatch Log Group. Valid values: api, audit, authenticator, controllerManager, scheduler |               | N        |

## Outputs
| Parameter           | Type   | Description               |
|---------------------|--------|---------------------------|
| eks_endpoint           | string | Endpoint of EKS cluster            |
| eks_id | string | Name of EKS cluster       |
| eks_arn    | string | ARN of EKS cluster  |
| eks_ca_data           | string | Certificate data of EKS cluster in base64 format            |
| eks_sg_id | string | ID of security group created and attached to EKS cluster      |

## Deployment
- `terraform init` - download plugins required to deploy resources
- `terraform plan` - get detailed view of resources that will be created, deleted or replaced
- `terraform apply -auto-approve` - deploy the template without confirmation (non-interactive mode)
- `terraform destroy -auto-approve` - terminate all the resources created using this template without confirmation (non-interactive mode)
