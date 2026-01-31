resource "helm_release" "nginx" {
  name = var.release_name

  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "nginx"
  namespace        = var.namespace
  create_namespace = var.create_namespace
  version          = var.chart_version
  timeout          = 600   # 10 minutes
  wait             = false # Don't wait for pods - allows debugging separately

  values = [file("${path.module}/values/nginx.yaml")]

  # Note: hostname is intentionally not set to allow access via ALB hostname or custom domain
  # Health check uses "/" (nginx root) not the ingress path
  # Certificate ARN removed for HTTP testing - add back for HTTPS
  set = [
    {
      name  = "ingress.path"
      value = var.ingress_path
    },
    {
      name  = "ingress.annotations.alb\\.ingress\\.kubernetes\\.io/group\\.name"
      value = var.alb_group_name
    }
  ]
}
