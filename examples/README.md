# Uses Cases ( How to test each feature in the module )  

There are different ways to parameterize the `terraform-fastly-service` (use case examples) in order to setup `myawesome-test` 
and demonstrate how we can `include/exclude`  different **features** in the module. 

Following pre-requisites are required:

- A S3 bucket
- Public permissions fot the bucket
- An object in the S3 bucket
- Public permission for the object

1. Create an `AWS bucket` named `myawesome-test`
   
   ![alt text](../images/1.uce-1-bucket.png)
   
2. Grant a public permission to the `myawesome-test` bucket
   
   ![alt text](../images/2.uce-1-bucketACL.png)
   
3. Upload an `object` image in the bucket
   
   ![alt text](../images/3.uce-1-objectinbucket.png)
   
4. Grant a public permission to the `object` image
   
   ![alt text](../images/4.uce-1-objectinbucketACL.png)
   
5. Access your `object` image from a browser
   
   ![alt text](../images/5.uce-1-accessingobjects3.png)

## Use Case 1: Fastly Service with TLS

In order to update our simple `fastly service` without TLS and provide `TLS feature` we need to parameterize the 
`terraform-fastly-service` in the following way:

```
domains = ["myawesome-test.exp.magnolia-cloud.com"]

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
```
Once you have parameterized the `terraform-fastly-service` execute the following commands to deploy it:

```
 terraform init
 terraform apply -var-file=examples/fastly_service_tls/tls.tfvars
```

Finally, we will see the `fastly service` upgrade, generating the certificates and more for the `TLS` feature ...

   ![alt text](../images/9.uce-2-fastlyservicetlsgenerating.png)

   ![alt text](../images/10.uce-2-fastlyservicetlsdetailsgenerating.png)
   
Let's check that the AWS Route53 records were created automatically too

   ![alt text](../images/11.uce-2-route53recordsadded.png)
   
Once the records and the validation has been created in `Fastly` we will see the `TLS` for our `fastly service` activated
with the domains specified

   ![alt text](../images/12.uce-2-fastlyservicetlsdone.png)

Let's see the fastly service `host` with the detail `TLS` configuration made

   ![alt text](../images/13.uce-2-fastlyservicetlsoverview.png)
   
Let's explore the `request setting` configuration as well

   ![alt text](../images/14.uce-2-fastlyservicetlsrequestsettings.png)

And again doing click in `Test domain` we will see the `myawesome-test` and `object` in XML format with `TLS` (secure)

   ![alt text](../images/15.uce-2-fastlyservicetlsaccess.png)
   
Now we can directly access from a `Web Browser` to the `object` image exposed on `Fastly` CDN directly

   ![alt text](../images/16.uce-2-fastlyservicetlsaccessobject.png)

## Use Case 2: Fastly Service with TLS and VCL (Snippets)

We can extend our `fastly service` using VCL language through [regular VCL snippets](https://docs.fastly.com/en/guides/using-regular-vcl-snippets), 
for instance we would like to [keep the content in cache in Fastly and not in browsers](https://developer.fastly.com/learning/concepts/cache-freshness/#cache-in-fastly-not-in-browsers), 
therefore we can extend the previously created `fastly service` by adding the corresponding snippet.

Let's first a request in the Web Browser and let's check the `Request Header` and the key `cache-control` first to verify that feature was enabled:

   ![alt text](../images/17.uce-3-cachefastlyandbrowser.png)

To configure the `terraform-fastly-service` to provide the desired behaviour ([keep the content in cache in Fastly and not in browsers](https://developer.fastly.com/learning/concepts/cache-freshness/#cache-in-fastly-not-in-browsers))
we can do it through a following snippet:

```
domains = ["myawesome-test.exp.magnolia-cloud.com"]

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
```

Once you have parameterized the `terraform-fastly-service` execute the following commands to deploy it:

```
 terraform init
 terraform apply -var-file=examples/fastly_service_tls_snippets/snippets.tfvars
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

## Use Case 3: Fastly Service with TLS, VCL (Snippets) optional director and shielding features

In this use case we will cover first a [director](https://developer.fastly.com/reference/api/load-balancing/directors/director/) feature ,
which enables for example 3 backends. 


The second case will be
[Shielding](https://docs.fastly.com/en/guides/shielding) (More info: [Point of Presence](https://developer.fastly.com/learning/concepts/shielding/#choosing-a-shield-location)) in Fastly to 
get the content from the closest location according to the request origin.

In order to use this feature must be required to activate `Image Optimizer` feature from Fastly

   ![alt text](../images/24.uce-5-fastlyimageoptimizer.png)

If we check the current `fastly service` created, we are going to see that this feature is disabled in our current setup

   ![alt text](../images/25.uce-5-fastlyimageoptimizerdisable.png)

So once requested the `Image Optimizer` feature from Fastly we can set it in config. 

```
domain = ["myawesome-test.exp.magnolia-cloud.com"]

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
#To enable shielding feature. Here we set a serving region: https://developer.fastly.com/learning/concepts/shielding/
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
```

Once you have parameterized the `terraform-fastly-service` run the following commands for deployment of the module:

```
 terraform init
 terraform apply -var-file=examples/fastly_service_tls_shielding_director/shielding_director.tfvars
```

After applying the above configuration we will see  `fastly_service` with `shielding`

   ![alt text](../images/26.uce-5-fastlyimageoptimizerenable.png)

And for the director feature: 

In fastly we will be able to see `director` feature in action like in the picture below

   ![alt text](../images/23.uce-4-fastlydirector3backends.png)


## Use Case 4: Fastly Service with TLS, VCL (Snippets) and monitoring (Datadog)

`terraform-fastly-service` covers the monitoring feature by using a [custom template](https://git.magnolia-cms.com/users/jvalderrama/repos/fastly_service/browse/monitoring/datadog/access_log_format_fastly.tpl)
for **Datadog** in order to push logs and related information. The important part to configure this is to set the correct 
`token` and `region` in the `login_datadog` variable object:

```
domains = ["myawesome-test.exp.magnolia-cloud.com"]

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
```

Once you have parameterized the `terraform-fastly-service` execute the following commands to deploy it:

```
 terraform init
 terraform apply -var-file=examples/fastly_service_tls_snippets_datadog/snippets_datadog.tfvars
```

After applying the above configuration we will see out `fastly_service` with `monitoring` in `Datadog` platform

   ![alt text](../images/27.uce-6-fastlydatadogintegration.png)

Let's check the details 

   ![alt text](../images/28.uce-6-fastlydatadogintegrationdetails.png)

## Use Case 5: Fastly Service with TLS and headers

`terraform-fastly-service` covers the **content headers** feature by configuring it in the fastly service.
For example we can enable cross-origin resources sharing (CORS) configuring by headers.

```
domains = ["myawesome-test.exp.magnolia-cloud.com"]

service_name      = "magnolia-cloud-myawesome-test-staging"
backend_address   = "myawesome-test.s3.eu-central-1.amazonaws.com"
port              = 443
use_ssl           = true
ssl_cert_hostname = "*.s3.eu-central-1.amazonaws.com"
ssl_check_cert    = true
ssl_sni_hostname  = "*.s3.eu-central-1.amazonaws.com"
max_connections   = 1000
override_host     = "myawesome-test.s3.eu-central-1.amazonaws.com"

request_settings = [
  {
    name      = "force_ssl"
    force_ssl = true
  }
]

headers = [
  {
    name          = "CORS S3 Allow"
    type          = "cache"
    action        = "set"
    destination   = "http.Access-Control-Allow-Origin"
    source        = "\"*\""
    ignore_if_set = false
    priority      = 10
  }
]

service_force_destroy = true

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
```

Once you have parameterized the `terraform-fastly-service` execute the following commands to deploy it:

```
 terraform init
 terraform apply -var-file=examples/fastly_service_tls_headers/headers.tfvars
```

After applying the above configuration we will see out `fastly_service` with `Content` in `headers` platform

![alt text](../images/29.uce-5-fastlyheaders.png)


That's all .....