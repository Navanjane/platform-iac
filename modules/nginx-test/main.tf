resource "helm_release" "nginx" {
  name = var.release_name

  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "nginx"
  namespace        = var.namespace
  create_namespace = var.create_namespace
  version          = var.chart_version

  values = [file("${path.module}/values/nginx.yaml")]

  # Note: hostname is intentionally not set to allow access via ALB hostname or custom domain
  set = [
    {
      name  = "ingress.path"
      value = var.ingress_path
    },
    {
      name  = "ingress.annotations.alb\\.ingress\\.kubernetes\\.io/certificate-arn"
      value = var.certificate_arn
    },
    {
      name  = "ingress.annotations.alb\\.ingress\\.kubernetes\\.io/group\\.name"
      value = var.alb_group_name
    },
    {
      name  = "ingress.annotations.alb\\.ingress\\.kubernetes\\.io/healthcheck-path"
      value = var.ingress_path
    }
  ]
}
