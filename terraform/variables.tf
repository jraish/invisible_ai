variable "instance_type" {
  default = "t2.micro"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  default = "11.0.0.0/16"
}

variable "prometheus_server_subnet_cidr1" {
  description = "Promethus Server Subnet CIDR"
  default = "11.0.1.0/24"
}

variable "environment" {
  default = "test"
}

variable "project_name" {
  default = "invisible_ai_prometheus"
}