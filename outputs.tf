locals {
  access_ip = "${var.floating_pool == "" ? openstack_compute_instance_v2.frontend.0.access_ip_v4 : element(concat(openstack_compute_floatingip_v2.frontend_vip.*.address, list("")), 0)}"
}

output "access_ip" {
  value = "${ local.access_ip }"
}
