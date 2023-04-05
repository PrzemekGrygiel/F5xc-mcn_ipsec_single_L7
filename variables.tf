variable "dccg" {
  type    = bool
  default = false
}

variable "via-re" {
  type    = bool
  default = false
}
variable "waf" {
  type    = bool
  default = false
}
variable "origin-pool-remote" {
  type    = bool
  default = false
}
variable "vip-ip" {
  default = "10.10.10.10"
}
# AWS Credential
variable "access_key" {
  description = "AWS Access Key"
  default     = ""
}
variable "secret_key" {
  description = "AWS Secret Key"
  default     = ""
}
variable "key_name" {
  default = "przemek-oregon"
}

variable "aws_cred_name" {
  description = "Volterra AWS Cred name"
  default     = "przemek-aws"
}
variable "key_path" {
  default = "/Users/grygiel/Documents/keys/aws/przemek-oregon.pem"
}

variable "aws_instance_type" {
  default = "t3.xlarge"
}

variable "projectPrefix" {
  default = "pg-single-test-ptf-trial"
}

variable "namespace" {
  default = "ptf-test"
}
variable "domain" {
  default = "example.com"
}

# AWS 
variable "aws_region" {
  default = "us-west-2"
}

# VPC configuration
variable "vpc1_cidr_block" {
  default = "10.130.0.0/16"
}
# VPC configuration
variable "vpc2_cidr_block" {
  default = "10.131.0.0/16"
}

variable "pg_vpc1_az_a_workload_vm_ip" {
  default = "10.130.1.100"
}


variable "pg_vpc2_az_a_workload_vm_ip" {
  default = "10.131.1.100"
}

