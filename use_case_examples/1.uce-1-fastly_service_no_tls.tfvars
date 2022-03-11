domain = "myawesome-test.exp.magnolia-cloud.com"

fastly_service = {
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
  force_destroy      = true
}

fastly_service_tls_enable_whit_aws = {
  enable                = false
  certificate_authority = "lets-encrypt"
  force_update          = true
  force_destroy         = true
  route_53_record       = null
  route_53_validation   = null
}

