resource "volterra_virtual_network" "global-network" {
  name        = format("%s-gn", var.projectPrefix)
  namespace = "system"
  global_network = true
}