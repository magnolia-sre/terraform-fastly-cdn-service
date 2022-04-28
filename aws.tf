resource "fastly_tls_subscription" "service" {
  domains               = fastly_service_vcl.service.domain[*].name
  certificate_authority = var.tls_certificate_authority
  force_update          = var.tls_force_update
  force_destroy         = var.tls_force_destroy
}

data "fastly_tls_configuration" "service" {
  id    = fastly_tls_subscription.service.configuration_id
}

data "aws_route53_zone" "magnolia_cloud_hosted_zone" {
  name  = regex("\\.(.*)", var.domain)[0]
}

resource "aws_route53_record" "service" {
  name    = var.domain
  type    = var.aws_route_53_record["type"]
  zone_id = data.aws_route53_zone.magnolia_cloud_hosted_zone.id
  records = [for dns_record in data.fastly_tls_configuration.service.dns_records : dns_record.record_value if dns_record.record_type == "CNAME"]
  ttl     = var.aws_route_53_record["ttl"]
}

resource "aws_route53_record" "service_validation" {
  name            = fastly_tls_subscription.service.managed_dns_challenge.record_name
  type            = fastly_tls_subscription.service.managed_dns_challenge.record_type
  zone_id         = data.aws_route53_zone.magnolia_cloud_hosted_zone.id
  allow_overwrite = var.aws_route_53_validation["allow_overwrite"]
  records         = [fastly_tls_subscription.service.managed_dns_challenge.record_value]
  ttl             = var.aws_route_53_validation["ttl"]
}

resource "fastly_tls_subscription_validation" "service" {
  depends_on      = [aws_route53_record.service_validation]
  subscription_id = fastly_tls_subscription.service.id
}
