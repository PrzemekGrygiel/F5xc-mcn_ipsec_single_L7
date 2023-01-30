resource "volterra_app_firewall" "pg-waf" {
  name      = "${var.projectPrefix}-waf"
  namespace = var.namespace
  monitoring = true
}