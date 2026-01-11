# Local variables
locals {
  # Only create resources if cluster_name is provided and not null
  create_resources  = var.cluster_name != null && var.cluster_name != ""
  safe_cluster_name = var.cluster_name != null ? var.cluster_name : "placeholder"
  safe_vpc_id       = var.vpc_id != null ? var.vpc_id : ""
}

# Data source for AWS Load Balancer Controller IAM policy
data "aws_iam_policy_document" "aws_load_balancer_controller" {
  count = local.create_resources ? 1 : 0

  source_policy_documents = [
    file("${path.module}/iam-policy.json")
  ]
}

# IAM Policy for AWS Load Balancer Controller
resource "aws_iam_policy" "aws_load_balancer_controller" {
  count = local.create_resources ? 1 : 0

  name        = "${local.safe_cluster_name}-aws-load-balancer-controller"
  path        = "/"
  description = "IAM policy for AWS Load Balancer Controller"
  policy      = data.aws_iam_policy_document.aws_load_balancer_controller[0].json

  tags = merge(
    var.tags,
    {
      Name      = "${local.safe_cluster_name}-aws-load-balancer-controller"
      ManagedBy = "terraform"
    }
  )
}

# IAM Role for Service Account (IRSA)
module "aws_load_balancer_controller_irsa" {
  count = local.create_resources ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name = "${local.safe_cluster_name}-aws-load-balancer-controller"

  attach_load_balancer_controller_policy = true

  oidc_providers = {
    main = {
      provider_arn               = var.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }

  tags = var.tags
}

# Helm Release for AWS Load Balancer Controller
resource "helm_release" "aws_load_balancer_controller" {
  count = local.create_resources ? 1 : 0

  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = var.chart_version

  set = [
    {
      name  = "clusterName"
      value = local.safe_cluster_name
    },
    {
      name  = "serviceAccount.create"
      value = "true"
    },
    {
      name  = "serviceAccount.name"
      value = "aws-load-balancer-controller"
    },
    {
      name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = module.aws_load_balancer_controller_irsa[0].iam_role_arn
    },
    {
      name  = "region"
      value = var.aws_region
    },
    {
      name  = "vpcId"
      value = local.safe_vpc_id
    },
    {
      name  = "enableShield"
      value = var.enable_shield
    },
    {
      name  = "enableWaf"
      value = var.enable_waf
    },

    {
      name  = "enableWafv2"
      value = var.enable_wafv2
    },
    {
      name  = "resources.limits.cpu"
      value = var.resources_limits_cpu
    },
    {
      name  = "resources.limits.memory"
      value = var.resources_limits_memory
    },
    {
      name  = "resources.requests.cpu"
      value = var.resources_requests_cpu
    },
    {
      name  = "resources.requests.memory"
      value = var.resources_requests_memory
    }


  ]






  depends_on = [
    module.aws_load_balancer_controller_irsa
  ]
}
