domain = "myawesome-test.exp.magnolia-cloud.com"

service_name       = "magnolia-cloud-myawesome-test-staging"
director           = false
backend_address    = "myawesome-test.s3.eu-central-1.amazonaws.com"
number_of_backends = 1
port               = 80
use_ssl            = false
ssl_cert_hostname  = ""
ssl_check_cert     = false
ssl_sni_hostname   = ""
auto_loadbalance   = false
max_connections    = 1000
override_host      = "myawesome-test.s3.eu-central-1.amazonaws.com"
shield             = null
request_settings   = []
snippets           = []
logging_datadog    = []
service_force_destroy      = true

enable_tls            = false
tls_certificate_authority = "lets-encrypt"
tls_force_update          = true
tls_force_destroy         = true
aws_route_53_record       = null
aws_route_53_validation   = null