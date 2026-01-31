# DNS record pointing platform subdomain to ALB
resource "aws_route53_record" "platform" {
  zone_id = var.zone_id
  name    = var.domain_name
  type    = "CNAME"
  ttl     = 300
  records = [var.alb_dns_name]
}
