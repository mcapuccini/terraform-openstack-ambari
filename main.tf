module "network" {
  source            = "modules/os-network"
  name_prefix       = "${var.cluster_prefix}"
  external_net_uuid = "${var.external_net_uuid}"
}

module "secgroup" {
  source      = "modules/os-secgroup"
  name_prefix = "${var.cluster_prefix}"
}

module "server_ignition" {
  source                     = "modules/ignition-server"
  ambari_server_docker_image = "${var.ambari_server_docker_image}"
  ambari_db_docker_image = "${var.ambari_db_docker_image}"
  public_key                 = "${var.public_key}"
  ambari_db_username = "${var.ambari_db_username}"
  ambari_db_password = "${var.ambari_db_password}"
}

module "server" {
  source             = "modules/os-node"
  name_prefix        = "${var.cluster_prefix}-server"
  count              = "1"
  flavor_name        = "${var.server_flavor_name}"
  image_name         = "${var.coreos_image_name}"
  network_name       = "${module.network.network_name}"
  secgroup_name      = "${module.secgroup.secgroup_name}"
  assign_floating_ip = "true"
  floating_ip_pool   = "${var.floating_ip_pool}"
  bootstrap_script   = "${module.server_ignition.user_data}"
}

module "agent_ignition" {
  source                    = "modules/ignition-agent"
  ambari_agent_docker_image = "${var.ambari_agent_docker_image}"
  ambari_server_hostname    = "${element(module.server.hostnames,0)}"
  ambari_server_address     = "${element(module.server.local_ip_list,0)}"
  public_key                = "${var.public_key}"
}

module "agents" {
  source           = "modules/os-node"
  name_prefix      = "${var.cluster_prefix}-agent"
  count            = "${var.agents_count}"
  flavor_name      = "${var.agent_flavor_name}"
  image_name       = "${var.coreos_image_name}"
  network_name     = "${module.network.network_name}"
  secgroup_name    = "${module.secgroup.secgroup_name}"
  floating_ip_pool = "${var.floating_ip_pool}"
  bootstrap_script = "${module.agent_ignition.user_data}"
}
