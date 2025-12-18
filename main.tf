# Main Terraform configuration file
# This file orchestrates all modules and resources for the platform infrastructure


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
  single_nat_gateway     = false  # One NAT per AZ for high availability
  one_nat_gateway_per_az = true
  
  # VPC Flow Logs (optional - set to true for production)
  enable_flow_log = false
  
  tags = {
    Project     = "platform-iac"
    ManagedBy   = "terraform"
  }
}

# EKS Module - Uncomment when ready to deploy EKS cluster
# module "eks" {
#   source = "./modules/eks"
#   
#   cluster_name    = "platform-eks-dev"
#   cluster_version = "1.28"
#   
#   vpc_id             = module.vpc.vpc_id
#   private_subnet_ids = module.vpc.private_subnets
#   
#   tags = {
#     Environment = "dev"
#     Project     = "platform-iac"
#     ManagedBy   = "terraform"
#   }
#   
#   depends_on = [module.vpc]
# }

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
