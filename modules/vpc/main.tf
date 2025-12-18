# VPC Module using official Terraform AWS VPC Module v6.x
# This creates a production-ready VPC with public/private subnets across multiple AZs

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.5.1"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.availability_zones
  private_subnets = var.private_subnet_cidrs
  public_subnets  = var.public_subnet_cidrs

  # NAT Gateway configuration
  enable_nat_gateway     = var.enable_nat_gateway
  single_nat_gateway     = var.single_nat_gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az

  # DNS Support
  enable_dns_hostnames = true
  enable_dns_support   = true

  # VPC Flow Logs - Updated for v6.x
  enable_flow_log                                 = var.enable_flow_log
  flow_log_destination_type                       = "cloud-watch-logs"
  flow_log_cloudwatch_log_group_name_prefix       = "/aws/vpc-flow-log/"
  flow_log_cloudwatch_log_group_retention_in_days = 7
  create_flow_log_cloudwatch_iam_role             = var.enable_flow_log
  create_flow_log_cloudwatch_log_group            = var.enable_flow_log

  # Tags
  tags = merge(
    var.tags,
    {
      Name        = var.vpc_name
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  )

  # Subnet tags (important for EKS)
  public_subnet_tags = merge(
    var.public_subnet_tags,
    {
      "kubernetes.io/role/elb" = "1"
    }
  )

  private_subnet_tags = merge(
    var.private_subnet_tags,
    {
      "kubernetes.io/role/internal-elb" = "1"
    }
  )
}
