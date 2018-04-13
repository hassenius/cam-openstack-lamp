##################################
## Create the floating IP
##################################
#
# We will only create the floating IP if this is a self service network.
# Provider networks do not support floating IP, so if floating_pool is left
# empty we will enterprete this as deploying to provider network.
#
#
resource "openstack_compute_floatingip_v2" "frontend_vip" {
  count = "${var.floating_pool != "" ? 1 : 0}"
  depends_on = ["openstack_networking_router_v2.newrouter", "openstack_networking_subnet_v2.newsubnet"]
  pool = "${var.floating_pool}"
  region = "RegionOne"
}

resource "openstack_compute_floatingip_associate_v2" "frontend_vip" {
  count       = "${var.floating_pool != "" ? 1 : 0}"
  depends_on = ["openstack_networking_router_v2.newrouter", "openstack_networking_subnet_v2.newsubnet"]
  floating_ip = "${openstack_compute_floatingip_v2.frontend_vip.address}"
  instance_id = "${openstack_compute_instance_v2.frontend.0.id}"
  region = "RegionOne"
}


##################################
## Create network
##################################
#
# If requested, create self service network
# and associated subnets and routers
#

resource "openstack_networking_network_v2" "newnetwork" {
  count          = "${var.network_name == "" ? 1 : 0}"
  name           = "camcreated"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "newsubnet" {
  count           = "${var.network_name == "" ? 1 : 0}"
  name            = "newsubnet"
  network_id      = "${element(list("", openstack_networking_network_v2.newnetwork.id), 1)}"
  cidr            = "192.168.20.0/24"
  dns_nameservers = ["8.8.8.8", "8.8.4.4"]
  ip_version = 4
}

resource "openstack_networking_router_v2" "newrouter" {
  count               = "${var.network_name == "" ? 1 : 0}"
  name                = "camnet_router"
  admin_state_up      = true
  external_network_id = "${var.external_net_id}"
#  external_fixed_ip   {
#    subnet_id = "6701d6fb-9f90-4a13-8ccd-2aee24186943"
#  }
}

resource "openstack_networking_router_interface_v2" "camrouter_interface" {
  count     = "${var.network_name == "" ? 1 : 0}"
  depends_on = ["openstack_networking_router_v2.newrouter", "openstack_networking_subnet_v2.newsubnet"]
  router_id = "${element(list("", openstack_networking_router_v2.newrouter.id), 1)}"
  subnet_id = "${element(list("", openstack_networking_subnet_v2.newsubnet.id), 1)}"
}
