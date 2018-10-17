variable cluster_prefix {
  description = "Prefix for the cluster resources name"
  default     = "ambari"
}

variable public_key {
  description = "Local path to a SSH public key"
}

variable external_net_uuid {
  description = "External network UUID"
}

variable floating_ip_pool {
  description = "Name of the floating IP pool (often same as the external network name)"
}

variable server_flavor_name {
  description = "Flavor name to be used for the server node"
}

variable agent_flavor_name {
  description = "Flavor name to be used for the worker nodes"
}

variable agents_count {
  description = "Number of agents to deploy"
}

variable coreos_image_name {
  description = "Name of a CoreOS Container-Linux image in your project (to boot the nodes from)"
}

variable ambari_server_docker_image {
  description = "Ambari server Docker image"
  default     = "mcapuccini/ambari-server:2.7.1.0"
}

variable ambari_agent_docker_image {
  description = "Ambari agent Docker image"
  default     = "mcapuccini/ambari-agent:2.7.1.0"
}

variable ambari_db_docker_image {
  description = "Ambari DB Docker image"
  default     = "mcapuccini/ambari-db:2.7.1.0"
}

variable ambari_db_username {
  description = "Ambari DB username"
  default = "admin"
}

variable ambari_db_password {
  description = "Ambari DB password (even though the DB is behind a firewall you may want to change this)"
  default = "admin"
}
