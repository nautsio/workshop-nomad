# About this workshop
This workshop aims to provide a playground to learn Nomad's
features, pros and cons.

It assumes basic knowledge of Docker and Linux.

It is not a copy & paste walk through: it expects you to consult Nomad's documentation.

Questions are welcome!

!SLIDE
# What is Nomad
Nomad manages a cluster of machines and the running of applications on them.
It abstracts away the machines and location of the applications.

!SUB
# Key features
* Single binary for client & server
* No external dependencies
* Combines resource manager & scheduler
* Multi-Datacenter & Multi-Region aware
* Flexible workloads (Docker, Exec, Java, VM)
* Multiple OSes (Windows, Linux, BSD, OSX)

!SUB
# Some caveats
* Still in early development (version 0.1.2)
* Does not (yet) restart your containers when they die
* Supports but a subset of docker features
* Some features are undocumented (read the source!)
* Can't configure the agent with ENV variables
* What resources are still available?
* Where are my applications logging?
