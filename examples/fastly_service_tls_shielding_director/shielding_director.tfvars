domain = "myawesome-test.exp.magnolia-cloud.com"

service_name       = "magnolia-cloud-myawesome-test-staging"
#To enable director feature
director           = true
backend_address    = "myawesome-test.s3.eu-central-1.amazonaws.com"
number_of_backends = 1
port               = 443
use_ssl            = true
ssl_cert_hostname  = "*.s3.eu-central-1.amazonaws.com"
ssl_check_cert     = true
ssl_sni_hostname   = "*.s3.eu-central-1.amazonaws.com"
max_connections    = 1000
override_host      = "myawesome-test.s3.eu-central-1.amazonaws.com"
#Here we set a serving region
#https://developer.fastly.com/learning/concepts/shielding/
shield             = "frankfurt-de"
request_settings = [
  {
    name      = "force_ssl"
    force_ssl = true
  }
]
snippets        = [
  {
    #https://developer.fastly.com/learning/concepts/cache-freshness/#cache-in-fastly-not-in-browsers
    name     = "Content to be cached by Fastly but not by browsers"
    type     = "fetch"
    priority = 100
    content  = <<EOF
set beresp.http.Cache-Control = "private, no-store"; # Don't cache in the browser
set beresp.ttl = 3600s; # Cache in Fastly
return(deliver);
EOF
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