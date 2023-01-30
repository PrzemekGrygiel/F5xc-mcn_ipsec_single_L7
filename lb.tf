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
                location = "string:///AAAAE3BsYXlncm91bmQtd3RwcHZhb2cAAAABAAAAAAAAAG4CAAAABQOCX5jFAAABAO0SxofVOP47/NNin8p7AAW6hJLBRvvCmesEK+KeLIkAB+slZHrva3UkOcEcItTxfwesc0ezUeRLyNd3q3wRM6fPl8GfNmdl5GGXYWHIo2Am2zvBkXB68wKbu2rkY+CdNf8wYPC8t2x+bujqTF6lrkeEGnhXp4ndCdQSv5ZcekPZXlhrniYrfiQPWBcKLi3BZevZ0KFz4UrJpsqi3vt3EiySvm+XXco4Eu/ptntM7vtjtvzVJy7hEbtyFQXsOd3sAGnIYanDUcdmEOvqww5go/DIE8YEYkyMlZss6Mhi9Ean+sQ1m659Gco/oSsf9fJqhI7TauXlBk6+VgTa3L5gZ6MAAAEAkZvnqvyrgCrn5TzLV5br52byJTAeuN9WEjZkpucBi41o9KH4UwqkCsmy779BoQHKFBsFZMQDSv/gPE0ReEIIRp1Q+zPwm9VDsZtpAsFo6pgrM3z/gpehxbtZ+cKgGXEi5MTeqNIFivIqyVMph4eXP2kfyzyaenJWWQmQsKDzvFft8ld6qGYl24ngdxKF4OPHCLsJ0ltI4sIKSduL1tKQ2c+YaLlF4u9w9O9R/xpVBJL080ovEIOrmIuZhgM17AIBUGzChvRTIb1DLhMGg7eqJOdbFMRIk2c24YW9RtXhH4cTg4x8I2G2UqdyCro2rtgxT3Rbpg4bbZz3ybd4QIIzxMCyR1NRQVXQoyKiZ0jADTzyDGx79GvJw9qEFqntbaafmKcVZl+8btR8zHoQoqOKeZFpATW1tzR7KkYWLDzZxelavSd4Cm3No9w/lM0F/NB5jRgjmehMeYjilGRotf2JPHmhZgSy8lt+VKnHIpia0bjeBHfmvzoaJaVzLKANcNB5u+OadEbMqILbOsgAxX0NpkByK7YFgOlVoFcFsxVwBhQ8+oAL3Hlcb4O8y+tevnanRFNjJ2jiQjnVQhsQHUlND3AdnDiy3I6bkoSTRkDjf/XQxlkbDCZHimtP4vox3WyoPP5njvBnsq6Uy82cQnydyQZA+tjqUryChlTEDkfVjFJj4B+R7FCUWPFqYzbRsjeaIEO7tmsgfx6fbX7z0aTyBRRodbPvVTAG0poRXn92hwe6tC3NSKFz2jAl0eHz/zvctp1B/C5BbkRyY0yqVhBnCN3NZ7z9l5ePHnw9wMDfSSyRWMG4Xz1uxvYnEEE6JY/7pln1vC4E5xzNSRsFlRt+C+RtvX8LSErKi+pl4q/LNSs6kxEzbs+fzRUpyTMne3DL9Jl66/O0YcejXAFzTIwdAT9lytW3fhPVFvXCsjug/6SoSi7ZLeeT+m4KPbU59KOI7QMk8bD92TUonq5ItRsK1CJSCkUiY3zRoOJoIqmPRcpCxM62ERlXzCQ+zoFQPmS6FERAukZmsxp6AYWUV94h/MDfffQ4RLlhqjkGW9w9mfqnkCsMmksep4cFTaOzsNfnA/SajGxkRlrlAkd66Vs/7+kVvSJklFdGGvP4iog09E/j8PcNKFaaueS40NDxXYUZKzmZZcH7C59RmpGY04D4IU/vZWDoLDWu4I3xrncsXiRPVICBsDRG11wlfac37yEzMfEh1xfDKPiOTY19blKRfF811dUQfpo6kq9N466evNkHbKwRxO0hkRBo1gLKrYOEJSurTtsaJ6Xryd8Tywkw5PTFoPfi2w3zxePnaDjGrXIk6H8k3Usj9ECRY37A/dmVRSOBMEulFiYYlj754EoQs/xmZcVD3acD/B2Ag3cdwycS5n0jvuyJqhQB6WXO27ENU4YN1W3cOBf9J8FfzYPaOYiFVtzHnrHcrzRfvBhSw3NrE4r15QdnlBRJp8//PGXIhT7CPjtKkRb42pqD+4yo7wzfO6HK7jjKLinjCCeWPKGkOMIMdYdf8j1g93gTkr6KU65MP9tf4WjAZ0zNLA+jBtLKcym/+6fsq4MK4ps6t9fITEoIZW6OTiS7Fv/tRDEa0pyA12YE1Dc1YBR/fLD40URK8VCogV6f2jfP4GrOb6+uBdkYworzjVHD5S2kYtvAxnH7gM3IhcWdDbt5yvUDg4ODj+TTrjI71OERUZng6EBsH5ZZHvnXzxvjGEeeE5jrex64Yi0n2H4ZUgsj+v0KQEK5UNEDJDgwW2077ix420fOC3CLKFdSTXfXFas1Kco/Gxt5glCJXOhGl8Qs/hVsMk5K1DtQ5XxFRXgj9ihXkeB80IyEgA4hpXqwwkKa/S74cRo1rS7qBbc0ig16sqXQ5lyEi0xCESKN+s1KkcS94ghWWUqszaGNX5nFxJWW0s7Q8ac3+1eUhn5LOS6pq4+valv0FopiU6ERjQXIYhNMXcaaZQNQIuY6puKOWGBE4xuBicAY0BsnMQj4heyEY1cFWRg5x8UUV+PNVrCLF9o9NB3/gCwThehlPjluKTse2r3QkBJEqS7Q+roUHjTNL2OV5Wn87mQOj04l4NQ9yYP89RzNcuhUKN6CuX4tWlll52Wlf4TDUWXbsmUEfk1tb4o6EAcde7yvc1X64P/UtO/BGj4GIlSDgWzjoSuat1DPKe+paMqOCTLuUYcSTlJ+OM4NgmJCPujJYYSlf8jQ04Vi0hosU8V3iUo6ipVj5fu6F1fIFPIeyMZUdz6NWCaDvUACYJfnRIURID5Y9IRUg6cdyLFrDr10eOxKlEbHLiQoNyeUyE4cc/QilcCA35BNBvNP0FyflyuPcOsmQtHiv8fy4Z5odzxtdI1XUWtXBEh1vdBQuMpAbEZCMOb5ceJPVMjrgwtV2+e3t6nGa4nT7S0vIzrIy++ZzR84YHdt9wj9Z6QqopuT1CqH4b7LWIUvBItWctkrJEQwl5exLh9ZD7QAX2deseco94FuizbB2a21OnaGmhX7fsYEDtkamff+gqD6GBrxbEM4hJDMhf4WeITAkMbtjz2+yej/mSekGIPS5RgZtL2/KLGPxwenor4ALcbTTj0H1+XBj/wwEI3p8GIvZFtyQHw2i8Q2VpKXHviNDZSo5bD2J0yD6w=="
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

