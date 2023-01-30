resource "volterra_dc_cluster_group" "dccg" {
  name      = format("dccg-%s", var.projectPrefix)
  namespace = "system"
}