client {
  enabled = true

  network_interface = "eth1"
  # network_speed = 1000
  servers = ["ddd-01:4646", "ddd-02:4646", "ddd-03:4646"]

  # Filtering
  # node_class = "general"
  # meta {
  #   key = "value"
  # }

  # Configuration
  # options {
  #  key = "value"
  # }
}