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
