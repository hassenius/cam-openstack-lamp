##################################
# Configure the OpenStack network
##################################
variable "network_name" {
    description = "The name of the network to deploy to. Leave blank to create a new network."
    default     = ""
}

variable "external_net_id" {
    description = "Specify details if creating new network."
    default     = ""
}
variable "floating_pool" {
  description = "Name of the floating address pool to assign floating addresses from. Leave blank if using provider network which doesn't require floating ip."
  default     = ""
}
variable "keypair_name" {
    description = "Name of keypair to add to instance for admin use. Optional"
    default     = ""
}


#################################
##### ICP Instance details ######
#################################
variable "instance_name" {
  description = "Name of the deployment. Will be included in instance names"
  default     = "camdemo"
}

variable "image_name" {
  description = "Specify the name of the image to deploy instances from"
  default     = "Ubuntu_16.04-server"
}

variable "frontend_flavor" {
  description = "Specify instance flavor to provision front end server to"
  default     = "m1.small"
}
