# Data source to fetch ingress created by Helm chart
data "kubernetes_ingress_v1" "argocd" {
  count = var.enable_ingress ? 1 : 0

  metadata {
    name      = "argocd-server"
    namespace = var.namespace
  }

  depends_on = [
    helm_release.argocd
  ]
}
