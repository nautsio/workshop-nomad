# Node Management

This section will look at the various ways of adding and removing client nodes and
the same for server nodes.

!SUB
# Adding and removing client nodes

* Added nodes will show up in `nomad node-status`. New allocations may be scheduled on the new node.
* What happens if a stop a client node?
* What happens if we restart it?

!SUB
# Draining client nodes
A nice way to remove a client node from a cluster is to 'drain' it. To do this, set the 'drain' flag of the node to true.
Nomad will then kill off the tasks on the drained node
and reschedule them on other nodes.The node can then be safely stopped for maintenance or decommissioning.

Let's try it out!

https://nomadproject.io/docs/commands/node-drain.html

Questions:
* What happens when we turn off drain mode again?
* What happens if we stop a client node without draining first?

!SUB
# Kicking out a server node
A failing server node can be forced to leave the cluster with `nomad server-force-leave`

https://nomadproject.io/docs/commands/server-force-leave.html

```
vagrant@ddd-02:/etc/nomad.d$ nomad server-force-leave ddd-01.global
vagrant@ddd-02:/etc/nomad.d$ nomad server-members
Name           Addr          Port  Status  Proto  Build  DC   Region
ddd-02.global  172.17.8.102  4648  alive   2      0.1.2  dc1  global
ddd-03.global  172.17.8.103  4648  alive   2      0.1.2  dc1  global
ddd-01.global  172.17.8.101  4648  left    2      0.1.2  dc1  global
```

Questions:
* What happens if you force-leave a running server node?
* What happens if you restart a server node that has been forced out?

!SLIDE
# Resource Management

Nomad will schedule a task only a node that has enough resources available to run
that task. These can be CPU cycles, memory, disk, etc, but also network ports the task
wants to bind.

That is why each task *must* specify its required resources.

The nomad agent will 'fingerprint' every client node for its available resources, so
the cluster knows its capacity.

Let's play with resources settings in the job specifications.

!SUB
# Testing resource usage

A very convenient tool to test resource usage is 'stress'. It can generate CPU load, disk IO and
allocate memory. E.g.

```
$ stress --vm 1 --vm-bytes 256M --vm-keep
```

Will allocate 256 megabytes of memory and continuously touch it.

It can be run from Docker too, with the `jess/stress` container:

```
$ docker run --name stress --rm -ti jess/stress --vm 1 --vm-bytes 256M --vm-keep
stress: info: [1] dispatching hogs: 0 cpu, 0 io, 1 vm, 0 hdd
```

`docker stats stress` will show its resource usage and limits.

!SUB
# Exercises

Create a job that runs a 'stress' Docker container

Questions:

* what happens if you run a job that specifies more resources than available on any single node?
* Does Nomad take into account resources claimed by tasks that have not been started by Nomad?
* Can you overcommit resources?
* Does Nomad limit resources of Docker containers?
* What happens if a task starts to use more resources dan specified?
