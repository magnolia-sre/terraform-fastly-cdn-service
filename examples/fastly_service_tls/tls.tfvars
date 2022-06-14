domain = "myawesome-test.exp.magnolia-cloud.com"

service_name       = "magnolia-cloud-myawesome-test-staging"
backend_address    = "myawesome-test.s3.eu-central-1.amazonaws.com"
port               = 443
use_ssl            = true
ssl_cert_hostname  = "*.s3.eu-central-1.amazonaws.com"
ssl_check_cert     = true
ssl_sni_hostname   = "*.s3.eu-central-1.amazonaws.com"
max_connections    = 1000
override_host      = "myawesome-test.s3.eu-central-1.amazonaws.com"

request_settings = [
  {
    name      = "force_ssl"
    force_ssl = true
  }
]

service_force_destroy   = true

tls_certificate_authority = "lets-encrypt"
tls_force_update          = true
tls_force_destroy         = true
aws_route_53_record = {
  type = "CNAME"
  ttl  = 300
}
aws_route_53_validation = {
  allow_overwrite = true
  ttl             = 60
}