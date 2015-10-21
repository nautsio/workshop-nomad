client {
  enabled = true

  node_id = "nomad-client-1"
  network_interface = "eth1"
  network_speed = 1000
  servers = ["0.0.0.0:4646"]

  # Filtering
  node_class = "general"
  meta {
    key = "value"
  }

  # Configuration
  options {
    key = "value"
  }
}
