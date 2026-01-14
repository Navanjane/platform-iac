output "release_name" {
  description = "The name of the Helm release"
  value       = helm_release.argocd.name
}

output "namespace" {
  description = "The namespace where ArgoCD is deployed"
  value       = helm_release.argocd.namespace
}

output "chart_version" {
  description = "The version of the ArgoCD chart deployed"
  value       = helm_release.argocd.version
}

output "release_status" {
  description = "The status of the Helm release"
  value       = helm_release.argocd.status
}

output "release_metadata" {
  description = "Metadata of the Helm release"
  value       = helm_release.argocd.metadata
}

# Ingress Outputs
output "ingress_enabled" {
  description = "Whether ingress is enabled"
  value       = var.enable_ingress
}

output "ingress_hostname" {
  description = "Hostname of the ALB ingress (empty if ingress not enabled)"
  value       = var.enable_ingress ? try(data.kubernetes_ingress_v1.argocd[0].status[0].load_balancer[0].ingress[0].hostname, "") : ""
}

output "domain_name" {
  description = "Domain name for ArgoCD"
  value       = var.domain_name
}

output "argocd_url" {
  description = "Full URL to access ArgoCD"
  value       = var.enable_ingress && var.domain_name != "" ? "https://${var.domain_name}${var.ingress_path}" : ""
}

output "ingress_path" {
  description = "Path for ArgoCD ingress"
  value       = var.ingress_path
}
