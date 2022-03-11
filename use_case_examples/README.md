# Uses Cases (¡How to test each feature in the module!)  

Has been provided different ways to parameterize the `Gazelle module` (use case examples) in order to setup `myawesome-test` 
and show how we can `include/exclude` the different **features** given in the module. 

So, we need to have the next pre-requisites to play whit it:

- A S3 bucket
- Public permissions fot the bucket
- An object in the S3 bucket
- Public permission for the object

1. Create a `AWS bucket` named `myawesome-test`
   
   ![alt text](../images/1.uce-1-bucket.png)
   
2. Give the public permission to the `myawesome-test` bucket
   
   ![alt text](../images/2.uce-1-bucketACL.png)
   
3. Upload an `object` image in the bucket
   
   ![alt text](../images/3.uce-1-objectinbucket.png)
   
4. Give the public permission to the `object` image
   
   ![alt text](../images/4.uce-1-objectinbucketACL.png)
   
5. Access your `object` image from a browser
   
   ![alt text](../images/5.uce-1-accessingobjects3.png)

## Use Case 1: Fastly Service without TLS

In order to start whit the simplest `fastly service` we can parameterize the `Gazelle module` in the next way:

```
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

```

Once parameterized the `Gazelle module` just run the commands:
```
 terraform init
 terraform apply -var-file=use_case_examples/1.uce-1-fastly_service_no_tls.tfvars
```

Finally, we will see the simplest `fastly service` ready, without TLS, snippets, shielding, monitoring ...
   
   ![alt text](../images/6.uce-1-fastlyservice.png)

Let's see the fasyly service `host`
   
   ![alt text](../images/7.uce-1-fastlyservicehost.png)

And doing click in `Test domain` we will see the `myawesome-test` and `object` in XML format
   
   ![alt text](../images/8.uce-1-testfastlyservicedomain.png)

## Use Case 2: Fastly Service with TLS

In order to update our simple `fastly service` without TLS and provide `TLS feature` just we need to parameterize the 
`Gazelle module` in the next way:

```
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
```

Once parameterized the `Gazelle module` just run the commands:

```
 terraform init
 terraform apply -var-file=use_case_examples/2.uce-2-fastly_service_tls.tfvars
```

Finally, we will see the `fastly service` upgrade, generating the certificates and more for the `TLS` feature ...

   ![alt text](../images/9.uce-2-fastlyservicetlsgenerating.png)

   ![alt text](../images/10.uce-2-fastlyservicetlsdetailsgenerating.png)
   
Let's check the AWS Route53 records created automatically too

   ![alt text](../images/11.uce-2-route53recordsadded.png)
   
Once the records and the validation has been made in `Fastly` we will see the `TLS` for our `fastly service` activated
whit the domain specified

   ![alt text](../images/12.uce-2-fastlyservicetlsdone.png)

Let's see the fasyly service `host` whiy the detail `TLS` configuration made

   ![alt text](../images/13.uce-2-fastlyservicetlsoverview.png)
   
Let's explore the `request setting` configuration as well

   ![alt text](../images/14.uce-2-fastlyservicetlsrequestsettings.png)

And again doing click in `Test domain` we will see the `myawesome-test` and `object` in XML format whit `TLS` (secure)

   ![alt text](../images/15.uce-2-fastlyservicetlsaccess.png)
   
Now we can access directly from a `Web Browser` to the `object` image expose on `Fastly` CDN directly

   ![alt text](../images/16.uce-2-fastlyservicetlsaccessobject.png)

## Use Case 3: Fastly Service with TLS and VCL (Snippets)

We can extend our `fastly service` using VCL language through [regular VCL snippets](https://docs.fastly.com/en/guides/using-regular-vcl-snippets), 
for instance we would like to [keep the content in cache in Fastly and not in browsers](https://developer.fastly.com/learning/concepts/cache-freshness/#cache-in-fastly-not-in-browsers), 
therefore we can extend the `fastly service` previously created adding the corresponding snippet.

Let's first a request in the Web Browser and let's check the `Request Header` and the key `cache-control` first:

   ![alt text](../images/17.uce-3-cachefastlyandbrowser.png)

Let's configure the `Gazelle module` to provide the desired behaviour ([keep the content in cache in Fastly and not in browsers](https://developer.fastly.com/learning/concepts/cache-freshness/#cache-in-fastly-not-in-browsers))
through a snippet:

```
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
  logging_datadog = []
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
```

Once parameterized the `Gazelle module` just run the commands:

```
 terraform init
 terraform apply -var-file=use_case_examples/3.uce-3-fastly_service_tls_snippets.tfvars
```

Applied the configuration above we will see the `fastly service` upgraded

   ![alt text](../images/18.uce-3-cachefastlynobrowser.png)

Let's dig into the details, name, type and priority

   ![alt text](../images/19.uce-3-cachefastlynobrowsersnippet.png)

And finally the VCL added to the `fastly service` to have the desired behaviour 

   ![alt text](../images/20.uce-3-cachefastlynobrowsersnipetdetails.png)
   
To test the `snippets feature` open in a new Browser the `object` and check again the `Request Header` and the key 
`cache-control`, its value must be `private, no-store`

> **TIP**: If you use the same browser to test you will not see the change immediately because we are caching the response

   ![alt text](../images/21.uce-3-cachefastlynobrowsertest.png)


## Use Case 4: Fastly Service with TLS, VCL (Snippets) and director

We can extend our `fastly service` using a [director](https://developer.fastly.com/reference/api/load-balancing/directors/director/),
for instance we would like to 3 backends under a director, therefore we can extend the previous `fastly service` adding 
the corresponding configuration:

```
domain = "myawesome-test.exp.magnolia-cloud.com"

fastly_service = {
  service_name       = "magnolia-cloud-myawesome-test-staging"
  #https://developer.fastly.com/reference/api/load-balancing/directors/director/
  director           = true
  backend_address    = "myawesome-test.s3.eu-central-1.amazonaws.com"
  number_of_backends = 3 # Differs of 1 because director = true
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
  logging_datadog = []
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
```

Once parameterized the `Gazelle module` just run the commands:

```
 terraform init
 terraform apply -var-file=use_case_examples/4.uce-4-fastly_service_director.tfvars
```

We will see in the terraform plan new 2 backends more and the existing one added to a `director`, that is going to be 
added to our `fastly_service`

   ![alt text](../images/22.uce-4-fastlydirectorterraformplan.png)

Applied the configuration above we will see the `fastly service` upgraded using a `director` too

   ![alt text](../images/23.uce-4-fastlydirector3backends.png)


## Use Case 5: Fastly Service with TLS, VCL (Snippets) and shielding

[Shielding](https://docs.fastly.com/en/guides/shielding) is the availability to have [POP (Point of Presence)](https://developer.fastly.com/learning/concepts/shielding/#choosing-a-shield-location) in Fastly to 
get the content from the closest location according to the request origin.

In order to use this feature must be required to activate `Image Optimizer` feature from Fastly

   ![alt text](../images/24.uce-5-fastlyimageoptimizer.png)

If we check the current `fastly service` created, we are going to see that this feature is disabled in our current setup

   ![alt text](../images/25.uce-5-fastlyimageoptimizerdisable.png)

So once requested the `Image Optimizer` feature from Fastly we can proceed to set a POP for our `fastly_service`, it will 
be `frankfurt-de` :

```
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
  logging_datadog = []
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
```

Once parameterized the `Gazelle module` just run the commands:

```
 terraform init
 terraform apply -var-file=use_case_examples/1.uce-1-fastly_service_no_tls.tfvars
```

Applied the above configuration we will see out `fastly_service` whit `shielding`

   ![alt text](../images/26.uce-5-fastlyimageoptimizerenable.png)


## Use Case 6: Fastly Service with TLS, VCL (Snippets) and monitoring (Datadog)

`Gazelle module` cover the monitoring feature using a [custom template](https://git.magnolia-cms.com/users/jvalderrama/repos/fastly_service/browse/monitoring/datadog/access_log_format_fastly.tpl)
for **Datadog** in order to push logs and related there. The important part to configure this is to set the correct 
`token` and `region` in the `login_datadog` variable object:

```
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
      token  = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
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
```

Once parameterized the `Gazelle module` just run the commands:

```
 terraform init
 terraform apply -var-file=use_case_examples/1.uce-1-fastly_service_no_tls.tfvars
```

Applied the above configuration we will see out `fastly_service` whit `monitoring` in `Datadog` platform

   ![alt text](../images/27.uce-6-fastlydatadogintegration.png)

Let's check the details 

   ![alt text](../images/28.uce-6-fastlydatadogintegrationdetails.png)


That's all .....



