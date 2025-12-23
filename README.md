# Platform Infrastructure as Code

Terraform infrastructure for deploying a production-ready EKS cluster on AWS.

## Architecture

- **VPC**: Multi-AZ VPC with public/private subnets
- **IAM**: Terraform execution role  
- **EKS**: Kubernetes v1.34 with managed node groups
- **Addons**: CoreDNS, kube-proxy, VPC CNI

## CI/CD Pipeline

DAG Pipeline: terraform-plan → terraform-init → apply-iam → apply-vpc → apply-eks → generate-kubeconfig

## Quick Start

```bash
git clone <repo>
cd platform-iac
terraform init
terraform plan
```

## Deployment

**GitHub Actions**: Merge PR to main or manual trigger

**Local**:
```bash
terraform apply -target=module.iam -auto-approve
terraform apply -target=module.vpc -auto-approve
terraform apply -target=module.eks.module.eks.aws_eks_cluster.this -auto-approve
terraform apply -target=module.eks.module.eks -auto-approve
terraform apply -auto-approve
```

## Access EKS

Download kubeconfig from GitHub Actions artifacts or:

```bash
aws eks update-kubeconfig --region us-east-1 --name platform-eks-dev
kubectl get nodes
```

## Configuration

Edit main.tf to customize:
- Cluster version, node types, sizes
- VPC CIDR, subnets
- IAM permissions

## Destroying

```bash
terraform state rm module.iam
terraform destroy -auto-approve
```

## Troubleshooting

- Jobs skipped: Use manual trigger or merge PR to main
- IAM exists error: Expected, continues automatically
- Cannot assume role: IAM module creates policy

## Security

- Encrypted S3 state
- DynamoDB locking
- Private subnets
- KMS encryption

Built with Terraform and GitHub Actions
