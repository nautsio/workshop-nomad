# Failures
Since failures do happen, lets see how Nomad copes with them.

**Exercises**
* Kill a job forcefully. Does Nomad follow our restart policies?
* Kill a client. Does Nomad transfer the allocated jobs correctly?
* Kill one of the Nomad servers. Do we still have consensus? Can we still schedule jobs?
* Kill a VM. Does everything still work?
* Restart after all Nomad servers. Do they rejoin the cluster?
* Exhaust the resources on a node. Does everything still function correctly?
