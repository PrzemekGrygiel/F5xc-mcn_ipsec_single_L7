output "Client_VPC_ID" {
  value = aws_vpc.pg-vpc1.id
}
output "Client_Region" {
  value = var.aws_region
}
output "Client_AZ" {
  value = format("%sa", var.aws_region)
}
output "Client_Outside_subnet_id" {
  value = aws_subnet.pg-vpc1-outside-az-a-subnet.id
}
output "Client_VIP_IP" {
  value = var.vip-ip
}
output "Client_HTTP_LB_name" {
  value = volterra_http_loadbalancer.ptf-http-lb.name
}
output "Client_HTTPS_LB_name" {
  value = volterra_http_loadbalancer.ptf-https-lb.name
}
output "Client_Workload_subnet_id" {
  value = aws_subnet.pg-vpc1-workload-az-a-subnet.id
}
output "Client_site_name" {
  value = volterra_aws_vpc_site.aws_site1.name
}

output "Server_VPC_ID" {
  value = aws_vpc.pg-vpc2.id
}
output "Server_Region" {
  value = var.aws_region
}
output "Server_AZ" {
  value = format("%sa", var.aws_region)
}
output "Server_Outside_subnet_id" {
  value = aws_subnet.pg-vpc2-outside-az-a-subnet.id
}
output "Server_Workload_subnet_id" {
  value = aws_subnet.pg-vpc2-workload-az-a-subnet.id
}
output "Server_site_name" {
  value = volterra_aws_vpc_site.aws_site2.name
}