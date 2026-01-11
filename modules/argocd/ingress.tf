# Kubernetes Ingress for ArgoCD with ALB
resource "kubernetes_ingress_v1" "argocd" {
  count = var.enable_ingress ? 1 : 0

  metadata {
    name      = "argocd-server"
    namespace = var.namespace

    annotations = {
      # ALB Configuration
      "alb.ingress.kubernetes.io/scheme"      = "internet-facing"
      "alb.ingress.kubernetes.io/target-type" = "ip"

      # SSL/TLS Configuration
      "alb.ingress.kubernetes.io/certificate-arn" = var.certificate_arn
      "alb.ingress.kubernetes.io/listen-ports" = jsonencode([
        { HTTP = 80 },
        { HTTPS = 443 }
      ])
      "alb.ingress.kubernetes.io/ssl-redirect" = "443"
      "alb.ingress.kubernetes.io/ssl-policy"   = "ELBSecurityPolicy-TLS13-1-2-2021-06"

      # Backend Protocol
      "alb.ingress.kubernetes.io/backend-protocol" = "HTTP"

      # Health Check
      "alb.ingress.kubernetes.io/healthcheck-path"             = "/healthz"
      "alb.ingress.kubernetes.io/healthcheck-port"             = "8080"
      "alb.ingress.kubernetes.io/healthcheck-protocol"         = "HTTP"
      "alb.ingress.kubernetes.io/healthcheck-interval-seconds" = "15"
      "alb.ingress.kubernetes.io/healthcheck-timeout-seconds"  = "5"
      "alb.ingress.kubernetes.io/healthy-threshold-count"      = "2"
      "alb.ingress.kubernetes.io/unhealthy-threshold-count"    = "2"
      "alb.ingress.kubernetes.io/success-codes"                = "200"

      # ALB Attributes
      "alb.ingress.kubernetes.io/load-balancer-attributes" = join(",", [
        "idle_timeout.timeout_seconds=60",
        "routing.http2.enabled=true",
        "routing.http.drop_invalid_header_fields.enabled=true"
      ])

      # Tags
      "alb.ingress.kubernetes.io/tags" = join(",", [
        for k, v in merge(var.tags, {
          Name        = "argocd-alb"
          Application = "argocd"
          ManagedBy   = "terraform"
        }) : "${k}=${v}"
      ])

      # Group (for sharing ALB across multiple ingresses)
      "alb.ingress.kubernetes.io/group.name" = var.alb_group_name
    }
  }

  spec {
    ingress_class_name = "alb"

    rule {
      host = var.domain_name

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "argocd-server"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }

  depends_on = [
    helm_release.argocd
  ]
}

# Route53 A Record for ArgoCD (Alias to ALB)
resource "aws_route53_record" "argocd" {
  count = var.enable_ingress && var.create_dns_record ? 1 : 0

  zone_id = var.route53_zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = kubernetes_ingress_v1.argocd[0].status[0].load_balancer[0].ingress[0].hostname
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }

  depends_on = [
    kubernetes_ingress_v1.argocd
  ]
}
