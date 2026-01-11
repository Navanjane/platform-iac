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
  host                   = try(coalesce(module.eks.cluster_endpoint, "https://localhost"), "https://localhost")
  cluster_ca_certificate = try(base64decode(coalesce(module.eks.cluster_certificate_authority_data, "LS0tCg==")), "")

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      try(coalesce(module.eks.cluster_id, "dummy-cluster"), "dummy-cluster"),
      "--region",
      "us-east-1"
    ]
  }
}

provider "helm" {
  kubernetes = {
    host                   = try(coalesce(module.eks.cluster_endpoint, "https://localhost"), "https://localhost")
    cluster_ca_certificate = try(base64decode(coalesce(module.eks.cluster_certificate_authority_data, "LS0tCg==")), "")

    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args = [
        "eks",
        "get-token",
        "--cluster-name",
        try(coalesce(module.eks.cluster_id, "dummy-cluster"), "dummy-cluster"),
        "--region",
        "us-east-1"
      ]
    }
  }
}