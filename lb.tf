resource "volterra_http_loadbalancer" "ptf-http-lb" {
  name                            =  "${var.projectPrefix}-http-lb"
  namespace                       = var.namespace
  description                     = "HTTP loadbalancer object ${var.projectPrefix} test"
  domains                         = [ "${var.domain}" ]
  advertise_on_public_default_vip = false
  no_service_policies             = true
  disable_rate_limit              = true
  round_robin                     = true
  service_policies_from_namespace = true
  no_challenge                    = true
  disable_waf                     = true
  http {
    dns_volterra_managed = false
  }

 dynamic  "app_firewall" {
  for_each = var.waf ? [1] : []
    content {
      namespace = var.namespace
      name = volterra_app_firewall.pg-waf.name
    }
  }

  default_route_pools {
    pool {
      namespace = var.namespace
      name = "${var.origin-pool-remote == true ?  volterra_origin_pool.ptf-remote-pool.name : volterra_origin_pool.ptf-local-pool.name}"
    }
  }

    advertise_custom  { 
        advertise_where {
            port = 80
            site  {
              ip = var.vip-ip
              network = "SITE_NETWORK_INSIDE"
              site {
                namespace =  "system"
                name = volterra_aws_vpc_site.aws_site1.name
              }
            }
        }
    }
    


  depends_on = [volterra_tf_params_action.aws_site1,volterra_origin_pool.ptf-remote-pool]
}


resource "volterra_http_loadbalancer" "ptf-https-lb" {
  name                            =  "${var.projectPrefix}-https-lb"
  namespace                       = var.namespace
  description                     = "HTTP loadbalancer object ${var.projectPrefix} test"
  domains                         = [ "${var.domain}" ]
  advertise_on_public_default_vip = false
  no_service_policies             = true
  disable_rate_limit              = true
  round_robin                     = true
  service_policies_from_namespace = true
  no_challenge                    = true
  disable_waf                     = true

  https  {
      http_redirect = false
      add_hsts = false
      port = 443
      tls_parameters {
         tls_config {
          default_security = true
        }
        tls_certificates {
            certificate_url = "string:///LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUN3akNDQWFvQ0NRRGc0NVRYNWw0WlpEQU5CZ2txaGtpRzl3MEJBUXNGQURBak1Rc3dDUVlEVlFRR0V3SlEKVERFVU1CSUdBMVVFQXd3TFpYaGhiWEJzWlM1amIyMHdIaGNOTWpJeE1USTBNVEF6TVRJMldoY05Nak14TVRJMApNVEF6TVRJMldqQWpNUXN3Q1FZRFZRUUdFd0pRVERFVU1CSUdBMVVFQXd3TFpYaGhiWEJzWlM1amIyMHdnZ0VpCk1BMEdDU3FHU0liM0RRRUJBUVVBQTRJQkR3QXdnZ0VLQW9JQkFRQ3Rvam0waGVGK1BFWWpSZGhGZzB2eTBjQXAKK3kwYytZOG41MUV2V3dtKzBoUXBmZFVzRUhpcUtLdmNuZUJ6Mk9pcVhPZDM4cGdwK041d0lIUmVVNXJ4bVYzTQpxMFVGMUpOcW9OYVd0aCtlZFF1RGF2VjlxNG1ONTZ5K1pwREFucUNuVjVlTjF6a0lYZm5nZUoxbkxDZythazRSClhZcGN6Qm50WGQ2K1NRT1g0c2daWXp1empHWmJRMkxDamJkTEdNRVN0RGxaSXBsblpRa1BuMldWakNScGVjNlgKUElzS0QzRU9HUHI0MTBLaG1HR2FVZjBJVjFqeGpPLzlzb3FOODdqYmNjS0IvYlpuN0xudGVWT3Rzc3B1LzRXVQpBNTg2RVhPTngvdCswem45NFFPTEdLa1J0VWZ6cHhUMGFRTEh5bXY1S09lQ3BTWmNob1N1anRqdlY2SEhBZ01CCkFBRXdEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBS0tJVXRXR21mZWZLTFgzK25YSm45cTRrMDlXZSt3Y3FtOEIKNzA3ZjdjNXFGOUdTbzRXbCtXdk5YdHlUTG85ZGJnNEhuclJtak54ZWVsaWVZNTFRWlZURjV5Q0k5amJ3ODRiTgpVWmpWUVFHVk4zdUhlREswZGwveGgrdUs3a1d1T0pYQzFXUlJxN2tmNHdyYW1ZQ3dWN0J5ZCttSERCZ3J5T3RyCld2aHRBd1FSdjE1Rk9xeGtaRk92S2Q5WVUrUTE2UU5HTWZnd1ZFWW90bENGUjBoWTFZSVJMckdBWHlQaENyL3kKQnpmTHBXMzlyQm9UWnBXOHlhcytzOTlZOHZNL2Y1SkFzakd0cHh3R0RXRWpuQkdlZWpGdkFlMjNoOGFVR1RkNQpGNEs1T2M4YmdhNWpBb09PYjd6WHBqSmY0eDRVa1Y3TDNiK1p5UzJtekhXSFFXZE5uVFk9Ci0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0="
            private_key {
              blindfold_secret_info {
                location = "string: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"              
              }
              secret_encoding_type = "EncodingNone"
            }
         }
        no_mtls = true
      }
   }
 dynamic  "app_firewall" {
  for_each = var.waf ? [1] : []
    content {
      namespace = var.namespace
      name = volterra_app_firewall.pg-waf.name
    }
  }
  default_route_pools {
    pool {
      namespace = var.namespace
      #name = volterra_origin_pool.ptf-remote-pool.name
      name = "${var.origin-pool-remote == true ?  volterra_origin_pool.ptf-remote-pool.name : volterra_origin_pool.ptf-local-pool.name}"
    }
  }
  advertise_custom  { 
        advertise_where {
            port = 443
            site  {
              ip = var.vip-ip
              network = "SITE_NETWORK_INSIDE"
              site {
                namespace =  "system"
                name = volterra_aws_vpc_site.aws_site1.name
              }
            }
        }
    }
  depends_on = [volterra_tf_params_action.aws_site1,volterra_origin_pool.ptf-remote-pool]
}

