output "namespace" {
  description = "Namespace where nginx is deployed"
  value       = var.namespace
}

output "release_name" {
  description = "Helm release name"
  value       = helm_release.nginx.name
}

output "release_status" {
  description = "Status of the Helm release"
  value       = helm_release.nginx.status
}
