# Location
region = "eu-central-1"
datacenter = "datacenter-1"

# Node
name = "nomad-node-1"
data_dir = "/var/local/nomad"
bind_addr = "0.0.0.0"
ports: {
  http: 4646
  rpc: 4647
  serf: 4648
}
leave_on_interrupt: false
leave_on_terminate: false
disable_updates_check: false
disable_anonymous_signature: false

# Logging
enable_debug = true
enable_syslog = true
syslog_facility = "LOCAL0"
log_level = "INFO"

# Metrics
telemetry = {
  statsd_address = "localhost:8125"
}
