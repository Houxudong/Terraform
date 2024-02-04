variable "ak" {
  default = "xxxxxxx"
}
variable "sk" {
  default = "xxxxxxxxxxx"
}
variable "region" {
  default     = "BJJD"
  description = "avaliable zone you create resources"
}
variable "vpc_name" {
  default     = "testvpc1"
  description = "name of creating new VPC"
}
variable "subnet_name" {
  default     = "testsubnet1"
  description = "name of create new network"
}
variable "subnet_name1" {
  default = "testsubnet2"
}
variable "v4_address" {
  default     = "192.168.13.0/24"
  description = "range of ipv4 address"
}
variable "port_name" {
  default     = "porthxd1"
  description = "name of vpc port"
}
variable "securitygroup_name" {
  default     = "hxdsecuritygroup"
  description = "name of security group"
}
variable "ecs_name" {
  default     = "ecshxdtest"
  description = "name of ecs"
}
variable "password" {
  default = "xxxxxxx"
}