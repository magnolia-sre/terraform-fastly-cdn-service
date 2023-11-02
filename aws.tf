resource "fastly_tls_subscription" "service" {
  domains               = fastly_service_vcl.service.domain[*].name
  certificate_authority = var.tls_certificate_authority
  force_update          = var.tls_force_update
  force_destroy         = var.tls_force_destroy
}

data "fastly_tls_configuration" "service" {
  id = fastly_tls_subscription.service.configuration_id
}

data "aws_route53_zone" "magnolia_cloud_hosted_zone" {
  name = regex("\\.(.*)", var.domains[0])[0]
}

resource "aws_route53_record" "service" {

  for_each = toset(var.domains)

  name    = each.value
  type    = var.aws_route_53_record["type"]
  zone_id = data.aws_route53_zone.magnolia_cloud_hosted_zone.id
  records = [for dns_record in data.fastly_tls_configuration.service.dns_records : dns_record.record_value if dns_record.record_type == "CNAME"]
  ttl     = var.aws_route_53_record["ttl"]
}

#Reference https://registry.terraform.io/providers/fastly/fastly/latest/docs/resources/tls_subscription#example-usage
resource "aws_route53_record" "service_validation" {
  depends_on = [fastly_tls_subscription.service]

  for_each = {
  # The following `for` expression (due to the outer {}) will produce an object with key/value pairs.
  # The 'key' is the domain name we've configured (e.g. a.example.com, b.example.com)
  # The 'value' is a specific 'challenge' object whose record_name matches the domain (e.g. record_name is _acme-challenge.a.example.com).
  for domain in fastly_tls_subscription.service.domains :
  domain => element([
  for obj in fastly_tls_subscription.service.managed_dns_challenges :
  obj if obj.record_name == "_acme-challenge.${domain}" # We use an `if` conditional to filter the list to a single element
  ], 0)                                                   # `element()` returns the first object in the list which should be the relevant 'challenge' object we need
  }

  name            = each.value.record_name
  type            = each.value.record_type
  zone_id         = data.aws_route53_zone.magnolia_cloud_hosted_zone.id
  allow_overwrite = var.aws_route_53_validation["allow_overwrite"]
  records         = [each.value.record_value]
  ttl             = var.aws_route_53_validation["ttl"]
}

resource "fastly_tls_subscription_validation" "service" {
  depends_on      = [aws_route53_record.service_validation]
  subscription_id = fastly_tls_subscription.service.id
}
