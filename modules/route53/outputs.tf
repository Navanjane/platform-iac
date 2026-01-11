output "zone_id" {
  description = "The hosted zone ID"
  value       = aws_route53_zone.main.zone_id
}

output "name_servers" {
  description = "List of name servers for the hosted zone - UPDATE THESE AT YOUR DOMAIN REGISTRAR"
  value       = aws_route53_zone.main.name_servers
}

output "zone_arn" {
  description = "ARN of the hosted zone"
  value       = aws_route53_zone.main.arn
}

output "domain_name" {
  description = "The domain name of the hosted zone"
  value       = aws_route53_zone.main.name
}
