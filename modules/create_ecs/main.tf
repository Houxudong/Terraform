//Create a VPC 
resource "ecloud_vpc_order" "create_vpc" {
  name         = var.vpc_name
  network_name = var.subnet_name
  cidr         = var.v4_address
  cidr_v6      = "64"
  region       = var.region
}
//Create a subnet in VPC
resource "ecloud_vpc_network" "create_subnet" {
  availability_zone_hints = var.region
  network_name            = var.subnet_name1
  region                  = var.region
  router_id               = ecloud_vpc_order.create_vpc.router_id
  subnets {
    cidr        = "192.168.121.0/24"
    ip_version  = 4
    subnet_name = "subnetv4"
  }
  depends_on = [ecloud_vpc_order.create_vpc]
}
//Create security group for port
resource "ecloud_vpc_security_group" "create_securitygroup" {
  name = var.securitygroup_name
  type = "VM"
}
//create ssh rule
resource "ecloud_vpc_security_rule" "create_ssh_rule" {
  direction                = "ingress"
  protocol                 = "TCP"
  max_port_range           = "21"
  min_port_range           = "23"
  remote_type              = "cidr"
  remote_ip_prefix         = "192.168.1.0/24"
  description              = "ssh rule"
  remote_security_group_id = ecloud_vpc_security_group.create_securitygroup.id
  security_group_id        = ecloud_vpc_security_group.create_securitygroup.id
  depends_on               = [ecloud_vpc_security_group.create_securitygroup]
}
# resource "ecloud_vpc_security_rule" "create_mysql_rule" {
#   direction                = "ingress"
#   protocol                 = "TCP"
#   max_port_range           = "3305"
#   min_port_range           = "3307"
#   remote_type              = "cidr"
#   remote_ip_prefix         = "192.168.1.0/24"
#   description              = "ssh rule"
#   remote_security_group_id = ecloud_vpc_security_group.create_securitygroup.id
#   security_group_id        = ecloud_vpc_security_group.create_securitygroup.id
#   depends_on               = [ecloud_vpc_security_group.create_securitygroup]
# }
//create egress rule
# resource "ecloud_vpc_security_rule" "create_egress_ipv4" {
#   direction                = "egress"
#   protocol                 = "ANY"
#   ether_type               = "IPv4"
#   max_port_range           = 65535
#   min_port_range           = 1
#   remote_type              = "cidr"
#   remote_ip_prefix         = "0.0.0.0/0"
#   remote_security_group_id = ecloud_vpc_security_group.create_securitygroup.id
#   security_group_id        = ecloud_vpc_security_group.create_securitygroup.id
#   depends_on               = [ecloud_vpc_security_group.create_securitygroup]
# }

resource "ecloud_vpc_port" "create_port" {
  name       = var.port_name
  network_id = ecloud_vpc_network.create_subnet.id
  depends_on = [
    ecloud_vpc_order.create_vpc,
    ecloud_vpc_network.create_subnet
  ]
}

resource "ecloud_ecs_instance" "create_ecs" {
  region       = var.region
  billing_type = "HOUR"   #  必填 默认为HOUR,HOUR: 按量 MONTH: 包月 YEAR：包年
  vm_type      = "common" #  必填 默认为common 详情查看 https://ecloud.10086.cn/op-help-center/doc/article/40731
  cpu          = 2
  ram          = 4
  boot_volume {
    size        = 40
    volume_type = "performanceOptimization"
  }
  image_name = "BC-Linux 7.6 64位"
  networks {
    network_id = ecloud_vpc_network.create_subnet.id
  }
  name               = var.ecs_name
  password           = var.password
  quantity           = 1
  duration           = 0
  security_group_ids = [ecloud_vpc_security_group.create_securitygroup.id]
  depends_on = [
    ecloud_vpc_network.create_subnet,
    ecloud_vpc_security_group.create_securitygroup
  ]
}

resource "ecloud_vpc_port_bind_server" "bind_port" {
  port_id     = ecloud_vpc_port.create_port.id
  resource_id = ecloud_ecs_instance.create_ecs.id
  depends_on = [
    ecloud_vpc_port.create_port,
    ecloud_ecs_instance.create_ecs
  ]
}