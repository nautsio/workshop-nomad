# Workshop Setup
Prerequisites:
* Virtualbox >= 5
* Vagrant >= 1.6
* Enough memory > 4gb
* This project repository

!SUB
## Environment
The workshop environment consists of 3 VMs running Debian Jessie.
They have Docker v1.9, Nomad v0.1.2, Consul and Collectd preinstalled.
Configuration will still have to be done by you.

!SUB
## Collectd
Collectd will gather metrics on the VMs, Nomad and Consul, and send
them to a central machine so we can compare performance of the various schedulers.
