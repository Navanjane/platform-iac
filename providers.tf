provider "aws" {
  region = "us-east-1"

  # Conditionally assume role based on TF_VAR_use_iam_role environment variable
  # Set TF_VAR_use_iam_role=false for bootstrapping (initial deployment)
  # Set TF_VAR_use_iam_role=true for normal operations (default)
  dynamic "assume_role" {
    for_each = var.use_iam_role ? [1] : []
    content {
      role_arn = "arn:aws:iam::147145168434:role/terraform-execution-role"
    }
  }
}

provider "kubernetes" {
  host                   = can(module.eks.cluster_endpoint) ? module.eks.cluster_endpoint : "https://localhost"
  cluster_ca_certificate = can(module.eks.cluster_certificate_authority_data) ? base64decode(module.eks.cluster_certificate_authority_data) : ""

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      can(module.eks.cluster_id) ? module.eks.cluster_id : "dummy-cluster",
      "--region",
      "us-east-1"
    ]
  }
}

provider "helm" {
  kubernetes = {
    host                   = can(module.eks.cluster_endpoint) ? module.eks.cluster_endpoint : "https://localhost"
    cluster_ca_certificate = can(module.eks.cluster_certificate_authority_data) ? base64decode(module.eks.cluster_certificate_authority_data) : ""

    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args = [
        "eks",
        "get-token",
        "--cluster-name",
        can(module.eks.cluster_id) ? module.eks.cluster_id : "dummy-cluster",
        "--region",
        "us-east-1"
      ]
    }
  }
}