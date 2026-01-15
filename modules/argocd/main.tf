resource "helm_release" "argocd" {
  name = var.release_name

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = var.namespace
  create_namespace = var.create_namespace
  version          = var.chart_version

  # Use different values files based on ingress enablement
  values = var.enable_ingress ? (
    var.values_file != "" ? [
      file("${path.module}/values/argocd-secure.yaml"),
      file(var.values_file)
    ] : [file("${path.module}/values/argocd-secure.yaml")]
  ) : (
    var.values_file != "" ? [
      file("${path.module}/values/argocd.yaml"),
      file(var.values_file)
    ] : [file("${path.module}/values/argocd.yaml")]
  )

  # Set domain and ingress configuration dynamically if ingress is enabled
  # Note: hosts is intentionally not set to allow access via ALB hostname or custom domain
  # Certificate ARN removed for HTTP testing - add back for HTTPS
  set = var.enable_ingress && var.domain_name != "" ? [
    {
      name  = "global.domain"
      value = var.domain_name
    },
    {
      name  = "server.config.url"
      value = "http://${var.domain_name}${var.ingress_path}"
    },
    {
      name  = "server.ingress.paths[0]"
      value = var.ingress_path
    },
    {
      name  = "server.ingress.annotations.alb\\.ingress\\.kubernetes\\.io/group\\.name"
      value = var.alb_group_name
    },
    {
      name  = "server.ingress.annotations.alb\\.ingress\\.kubernetes\\.io/healthcheck-path"
      value = "/healthz"
    }
  ] : []
}