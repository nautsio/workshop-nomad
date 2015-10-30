server {
  enabled = true

  # Server
  bootstrap_expect = 3

  # Schedulers
  num_schedulers = 1
  enabled_schedulers = ["service", "batch"]
}
