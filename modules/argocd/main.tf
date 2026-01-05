resource "helm_release" "argocd" {
  name = var.release_name

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = var.namespace
  create_namespace = var.create_namespace
  version          = var.chart_version

  values = var.values_file != "" ? [
    file("${path.module}/values/argocd.yaml"),
    file(var.values_file)
  ] : [file("${path.module}/values/argocd.yaml")]
}