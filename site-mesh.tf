resource "volterra_virtual_site" "virtual_site" {
  name      = format("%s-vs", var.projectPrefix)
  namespace = "shared"

  site_selector {
    expressions = [format("pg-perf-label in (%s)", var.projectPrefix)]
  }

  site_type = "CUSTOMER_EDGE"
}

resource "volterra_site_mesh_group" "site-group" {
  name        = format("%s-mesh-group", var.projectPrefix)
  namespace   = "system"
  tunnel_type = "SITE_TO_SITE_TUNNEL_IPSEC"
  type        = "SITE_MESH_GROUP_TYPE_FULL_MESH"
  virtual_site {
    name = volterra_virtual_site.virtual_site.name
    namespace = "shared"
  }
}



