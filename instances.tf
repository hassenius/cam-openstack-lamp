###########################################
## Determine which network to deploy to.
## If existing, use the name provided,
## if not use the one we created.
###########################################
locals {
  network_name = "${coalesce(var.network_name, element(concat(openstack_networking_network_v2.newnetwork.*.name, list("")), 0))}"
}

##################################
## Frontend
##################################
resource "openstack_compute_instance_v2" "frontend" {
    count       = "1"
    name        = "${format("${lower(var.instance_name)}-frontend%01d", count.index + 1) }"
    image_name  = "${var.image_name}"
    flavor_name = "${var.frontend_flavor}"
    key_pair    = "${var.keypair_name}"

    network {
        name = "${local.network_name}"
    }

    #personality
}
