module "user" {
  source     = "../ignition-user"
  public_key = "${var.public_key}"
}

module "updates" {
  source = "../ignition-updates"
}

data "template_file" "ambari-server" {
  template = "${file("${path.module}/ambari-server.service")}"

  vars {
    ambari_server_docker_image = "${var.ambari_server_docker_image}"
    ambari_db_username = "${var.ambari_db_username}"
    ambari_db_password = "${var.ambari_db_password}"
  }
}

data "ignition_systemd_unit" "ambari-server" {
  name    = "ambari-server.service"
  enabled = true
  content = "${data.template_file.ambari-server.rendered}"
}

data "template_file" "ambari-db" {
  template = "${file("${path.module}/ambari-db.service")}"

  vars {
    ambari_db_docker_image = "${var.ambari_db_docker_image}"
    ambari_db_username = "${var.ambari_db_username}"
    ambari_db_password = "${var.ambari_db_password}"
  }
}

data "ignition_systemd_unit" "ambari-db" {
  name    = "ambari-db.service"
  enabled = true
  content = "${data.template_file.ambari-db.rendered}"
}

data "ignition_config" "bootstrap_config" {
  users = [
    "${module.user.id}",
  ]

  files = [
    "${module.updates.id}",
  ]

  systemd = [
    "${data.ignition_systemd_unit.ambari-server.id}",
    "${data.ignition_systemd_unit.ambari-db.id}",
  ]
}
