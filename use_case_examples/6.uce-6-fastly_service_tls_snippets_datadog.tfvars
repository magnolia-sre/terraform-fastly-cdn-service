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
  logging_datadog = [
    {
      name   = "datadog-myawesome-test-staging"
      token  = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
      region = "EU"
    }
  ]
  force_destroy   = true
}

fastly_service_tls_enable_whit_aws = {
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
