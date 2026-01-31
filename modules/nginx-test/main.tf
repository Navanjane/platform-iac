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

  set = concat([
    {
      name  = "ingress.path"
      value = var.ingress_path
    },
    {
      name  = "ingress.annotations.alb\\.ingress\\.kubernetes\\.io/group\\.name"
      value = var.alb_group_name
    }
    ],
    var.certificate_arn != "" ? [
      {
        name  = "ingress.annotations.alb\\.ingress\\.kubernetes\\.io/certificate-arn"
        value = var.certificate_arn
      }
    ] : []
  )
}
