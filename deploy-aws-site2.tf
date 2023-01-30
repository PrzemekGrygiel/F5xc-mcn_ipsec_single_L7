# Create aws vpc sites for site mesh group
resource "volterra_aws_vpc_site" "aws_site2" {
  name          = format("%s-2", var.projectPrefix)
  namespace     = "system"
  aws_region    = var.aws_region

  aws_cred {
      name = var.aws_cred_name
      namespace = "system"
  }

  vpc {
    vpc_id = "${aws_vpc.pg-vpc2.id}"
  }

  instance_type = var.aws_instance_type

  ingress_egress_gw {
    sm_connection_pvt_ip = false
    aws_certified_hw  = "aws-byol-multi-nic-voltmesh"
    inside_static_routes {
      static_route_list {
        simple_static_route = "10.131.1.0/24"
      }
    }
    az_nodes {
      aws_az_name = format("%sa", var.aws_region)    
      outside_subnet {
         existing_subnet_id = aws_subnet.pg-vpc2-outside-az-a-subnet.id
      }    
      workload_subnet {
        existing_subnet_id = aws_subnet.pg-vpc2-workload-az-a-subnet.id
      }
      inside_subnet {
        existing_subnet_id = aws_subnet.pg-vpc2-inside-az-a-subnet.id
      }
    }
  
    global_network_list {
      global_network_connections {
        sli_to_global_dr {
          global_vn {
            name = format("%s-gn", var.projectPrefix)
          }
        }
      }
    }
   dynamic "dc_cluster_group_outside_vn" {
      for_each = var.dccg ? [1] : []
      content {
          namespace = "system"
          name      = format("dccg-%s", var.projectPrefix)
      }
    }
  }
  lifecycle {
    ignore_changes = [ labels ]
  }

  logs_streaming_disabled   = true
}

resource "volterra_cloud_site_labels" "label2" {
  name = volterra_aws_vpc_site.aws_site2.name
    site_type = "aws_vpc_site"
    labels = {
      pg-perf-label = "${var.dccg == true || var.via-re == true  ?  format("%s-null",var.projectPrefix) : var.projectPrefix}"
    }
  ignore_on_delete = true
}

resource "volterra_tf_params_action" "aws_site2" {
  site_name        = volterra_aws_vpc_site.aws_site2.name
  site_kind        = "aws_vpc_site"
  action           = "apply"
  wait_for_action  = true
  ignore_on_update = false

  depends_on = [volterra_aws_vpc_site.aws_site2]
}
