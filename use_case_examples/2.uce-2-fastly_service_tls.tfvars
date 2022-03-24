domain = "myawesome-test.exp.magnolia-cloud.com"

fastly_service = {
  service_name       = "magnolia-cloud-myawesome-test-staging"
  director           = false
  backend_address    = "myawesome-test.s3.eu-central-1.amazonaws.com"
  number_of_backends = 1
  port               = 443
  use_ssl            = true
  ssl_cert_hostname  = "*.s3.eu-central-1.amazonaws.com"
  ssl_check_cert     = true
  ssl_sni_hostname   = "*.s3.eu-central-1.amazonaws.com"
  auto_loadbalance   = false
  max_connections    = 1000
  override_host      = "myawesome-test.s3.eu-central-1.amazonaws.com"
  shield             = null
  request_settings = [
    {
      name      = "force_ssl"
      force_ssl = true
    }
  ]
  snippets        = []
  logging_datadog = []
  force_destroy   = true
}

fastly_service_tls_enable_with_aws = {
  enable                = true
  certificate_authority = "lets-encrypt"
  force_update          = true
  force_destroy         = true
  route_53_record = {
    type = "CNAME"
    ttl  = 300
  }
  route_53_validation = {
    allow_overwrite = true
    ttl             = 60
  }
}

