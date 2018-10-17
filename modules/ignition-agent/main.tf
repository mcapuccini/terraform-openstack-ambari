module "user" {
  source     = "../ignition-user"
  public_key = "${var.public_key}"
}

module "updates" {
  source = "../ignition-updates"
}

data "template_file" "ambari-agent" {
  template = "${file("${path.module}/ambari-agent.service")}"

  vars {
    ambari_agent_docker_image = "${var.ambari_agent_docker_image}"
    ambari_server_hostname    = "${var.ambari_server_hostname}"
    ambari_server_address     = "${var.ambari_server_address}"
  }
}

data "ignition_systemd_unit" "ambari-agent" {
  name    = "ambari-agent.service"
  enabled = true
  content = "${data.template_file.ambari-agent.rendered}"
}

data "ignition_config" "bootstrap_config" {
  users = [
    "${module.user.id}",
  ]

  files = [
    "${module.updates.id}",
  ]

  systemd = [
    "${data.ignition_systemd_unit.ambari-agent.id}",
  ]
}
