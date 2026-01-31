# Main Terraform configuration file
# This file orchestrates all modules and resources for the platform infrastructure

# Look up existing Route53 hosted zone
data "aws_route53_zone" "platform" {
  name         = var.hosted_zone_name
  private_zone = false
}

# IAM Module - Creates terraform execution role and policies
module "iam" {
  source = "./modules/iam"
}

# VPC Module - Creates VPC with public/private subnets
module "vpc" {
  source = "./modules/vpc"

  vpc_name    = "platform-vpc-dev"
  vpc_cidr    = "10.0.0.0/16"
  environment = "dev"

  availability_zones   = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnet_cidrs  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  # NAT Gateway configuration
  enable_nat_gateway     = true
  single_nat_gateway     = false # One NAT per AZ for high availability
  one_nat_gateway_per_az = true

  # VPC Flow Logs (optional - set to true for production)
  enable_flow_log = false

  tags = {
    Project   = "platform-iac"
    ManagedBy = "terraform"
  }
}

# EKS Module - Creates EKS cluster with managed node groups
module "eks" {
  source = "./modules/eks"

  cluster_name    = "platform-eks-dev"
  cluster_version = "1.34"

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets

  # Cluster endpoint access
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  # Enable cluster logging
  cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  # Node group configuration
  node_group_instance_types = ["t3.medium"]
  node_group_capacity_type  = "ON_DEMAND"
  node_group_min_size       = 1
  node_group_max_size       = 3
  node_group_desired_size   = 2
  node_group_disk_size      = 20

  tags = {
    Environment = "dev"
    Project     = "platform-iac"
    ManagedBy   = "terraform"
  }

  depends_on = [module.vpc]
}

# ACM Certificate Module - SSL/TLS Certificate
# DNS validation is automatic via Route53
module "acm" {
  source = "./modules/acm"

  domain_name               = var.domain_name
  subject_alternative_names = []
  environment               = "dev"

  skip_dns_validation = false
  route53_zone_id     = data.aws_route53_zone.platform.zone_id

  tags = {
    Environment = "dev"
    Project     = "platform-iac"
    ManagedBy   = "terraform"
    Application = "platform"
  }

  depends_on = [module.vpc]
}

# AWS Load Balancer Controller Module
module "aws_load_balancer_controller" {
  source = "./modules/aws-load-balancer-controller"

  cluster_name      = "platform-eks-dev" # Hardcoded to avoid null during targeted applies
  vpc_id            = module.vpc.vpc_id
  oidc_provider_arn = try(module.eks.oidc_provider_arn, null)
  oidc_provider     = try(module.eks.oidc_provider, null)
  aws_region        = "us-east-1"

  # Chart version
  chart_version = "1.11.0"

  # Optional features
  enable_shield = false
  enable_waf    = false
  enable_wafv2  = false

  tags = {
    Environment = "dev"
    Project     = "platform-iac"
    ManagedBy   = "terraform"
  }

  depends_on = [module.eks]
}

# ArgoCD Module - GitOps Continuous Delivery
module "argocd" {
  source = "./modules/argocd"

  # Enable ingress with ALB (managed by Helm chart)
  enable_ingress  = true
  domain_name     = var.domain_name
  ingress_path    = "/argocd"
  certificate_arn = module.acm.certificate_arn

  # ALB configuration
  alb_group_name = "platform-alb-dev"

  tags = {
    Environment = "dev"
    Project     = "platform-iac"
    ManagedBy   = "terraform"
  }

  depends_on = [
    module.eks,
    module.aws_load_balancer_controller,
    module.acm
  ]
}

# Nginx Test Module - For testing ALB ingress
module "nginx_test" {
  source = "./modules/nginx-test"

  domain_name     = var.domain_name
  ingress_path    = "/test"
  certificate_arn = module.acm.certificate_arn
  alb_group_name  = "platform-alb-dev"

  depends_on = [
    module.eks,
    module.aws_load_balancer_controller,
    module.acm
  ]
}

# Route53 Module - DNS record pointing to ALB
module "route53" {
  source = "./modules/route53"

  zone_id      = data.aws_route53_zone.platform.zone_id
  domain_name  = var.domain_name
  alb_dns_name = module.argocd.ingress_hostname
  environment  = "dev"

  depends_on = [module.argocd]
}

# ========================================
# Outputs
# ========================================


# IAM Outputs
output "terraform_role_arn" {
  description = "ARN of the Terraform execution role"
  value       = module.iam.terraform_role_arn
}

output "terraform_role_name" {
  description = "Name of the Terraform execution role"
  value       = module.iam.terraform_role_name
}

output "terraform_policy_arn" {
  description = "ARN of the Terraform provisioning policy"
  value       = module.iam.terraform_policy_arn
}

# VPC Outputs
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs"
  value       = module.vpc.nat_gateway_ids
}

# EKS Outputs
output "eks_cluster_id" {
  description = "The ID/name of the EKS cluster"
  value       = module.eks.cluster_id
}

output "eks_cluster_endpoint" {
  description = "Endpoint for your Kubernetes API server"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_version" {
  description = "The Kubernetes version for the cluster"
  value       = module.eks.cluster_version
}

output "eks_cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = module.eks.cluster_security_group_id
}

output "eks_node_security_group_id" {
  description = "Security group ID attached to the EKS nodes"
  value       = module.eks.node_security_group_id
}

output "eks_oidc_provider_arn" {
  description = "ARN of the OIDC Provider for EKS"
  value       = module.eks.oidc_provider_arn
}

output "eks_cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = module.eks.cluster_certificate_authority_data
  sensitive   = true
}

# ArgoCD Outputs
output "argocd_release_name" {
  description = "The name of the ArgoCD Helm release"
  value       = module.argocd.release_name
}

output "argocd_namespace" {
  description = "The namespace where ArgoCD is deployed"
  value       = module.argocd.namespace
}

output "argocd_chart_version" {
  description = "The version of the ArgoCD chart deployed"
  value       = module.argocd.chart_version
}

output "argocd_url" {
  description = "HTTPS URL to access ArgoCD"
  value       = module.argocd.argocd_url
}

output "argocd_alb_hostname" {
  description = "ALB hostname for the platform"
  value       = module.argocd.ingress_hostname
}

output "domain_name" {
  description = "Platform root domain"
  value       = var.domain_name
}

output "argocd_ingress_path" {
  description = "Path for ArgoCD access"
  value       = module.argocd.ingress_path
}

# ACM Outputs
output "acm_certificate_arn" {
  description = "ARN of the ACM certificate"
  value       = module.acm.certificate_arn
}

output "acm_certificate_status" {
  description = "Status of the ACM certificate"
  value       = module.acm.certificate_status
}

output "acm_dns_validation_records" {
  description = "DNS validation records for the certificate"
  value       = module.acm.dns_validation_records
}

# Route53 Outputs
output "route53_zone_id" {
  description = "Route53 hosted zone ID"
  value       = data.aws_route53_zone.platform.zone_id
}

output "route53_name_servers" {
  description = "Route53 hosted zone name servers"
  value       = data.aws_route53_zone.platform.name_servers
}

output "route53_record_fqdn" {
  description = "FQDN of the platform DNS record"
  value       = module.route53.record_fqdn
}

# ALB Controller Outputs
output "alb_controller_role_arn" {
  description = "IAM role ARN for AWS Load Balancer Controller"
  value       = module.aws_load_balancer_controller.iam_role_arn
}

output "alb_controller_status" {
  description = "Status of ALB controller Helm release"
  value       = module.aws_load_balancer_controller.helm_release_status
}

# Nginx Test Outputs
output "nginx_test_namespace" {
  description = "Namespace where nginx test is deployed"
  value       = module.nginx_test.namespace
}

output "nginx_test_url" {
  description = "URL to access nginx test"
  value       = "https://${var.domain_name}/test"
}
