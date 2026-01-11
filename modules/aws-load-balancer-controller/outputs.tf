output "iam_role_arn" {
  description = "ARN of the IAM role for AWS Load Balancer Controller"
  value       = try(module.aws_load_balancer_controller_irsa[0].iam_role_arn, "")
}

output "iam_role_name" {
  description = "Name of the IAM role"
  value       = try(module.aws_load_balancer_controller_irsa[0].iam_role_name, "")
}

output "service_account_name" {
  description = "Name of the Kubernetes service account"
  value       = "aws-load-balancer-controller"
}

output "namespace" {
  description = "Namespace where the controller is deployed"
  value       = "kube-system"
}

output "helm_release_name" {
  description = "Name of the Helm release"
  value       = try(helm_release.aws_load_balancer_controller[0].name, "")
}

output "helm_release_status" {
  description = "Status of the Helm release"
  value       = try(helm_release.aws_load_balancer_controller[0].status, "")
}
