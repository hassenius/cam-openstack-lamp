##################################
## Create the Security Groups
##################################
resource "openstack_networking_secgroup_v2" "frontend" {
  name        = "frontend"
  description = "Security Group for Frontend servers"
}


##########################################
#### Create the Security Group Rules #####
##########################################
resource "openstack_networking_secgroup_rule_v2" "web" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.frontend.id}"
}

resource "openstack_networking_secgroup_rule_v2" "ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_group_id   = "${openstack_networking_secgroup_v2.frontend.id}"
  security_group_id = "${openstack_networking_secgroup_v2.frontend.id}"
}
