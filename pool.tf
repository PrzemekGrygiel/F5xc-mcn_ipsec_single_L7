resource "volterra_origin_pool" "ptf-remote-pool" {
  name                   = "${var.projectPrefix}-remote-pool"
  namespace              = var.namespace
  endpoint_selection     = "DISTRIBUTED"
  loadbalancer_algorithm = "LB_OVERRIDE"
  port                   = 80
  no_tls                 = true

  origin_servers {
    private_ip {
      ip             = "10.131.1.200"
      inside_network = true
      site_locator {
        site {
          namespace = "system"
          name      = volterra_aws_vpc_site.aws_site2.name
        }
      }
    }
    private_ip {
      ip             = "10.131.1.201"
      inside_network = true
      site_locator {
        site {
          namespace = "system"
          name      = volterra_aws_vpc_site.aws_site2.name
        }
      }
    }
  }
  depends_on = [volterra_tf_params_action.aws_site2]
}

resource "volterra_origin_pool" "ptf-local-pool" {
  name                   = "${var.projectPrefix}-local-pool"
  namespace              = var.namespace
  endpoint_selection     = "DISTRIBUTED"
  loadbalancer_algorithm = "LB_OVERRIDE"
  port                   = 80
  no_tls                 = true

  origin_servers {
    private_ip {
      ip             = "10.130.1.200"
      inside_network = true
      site_locator {
        site {
          namespace = "system"
          name      = volterra_aws_vpc_site.aws_site1.name
        }
      }
    }
    private_ip {
      ip             = "10.130.1.201"
      inside_network = true
      site_locator {
        site {
          namespace = "system"
          name      = volterra_aws_vpc_site.aws_site1.name
        }
      }
    }
  }
  depends_on = [volterra_tf_params_action.aws_site1]
}