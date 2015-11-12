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
* Doesn't restart your containers when they die
* Implements a subset of docker features
* Not all features are documented
* Can't configure the agent with ENV variables
* What resources are still available?
* Where are my applications logging?

!SLIDE
# Architecture
Clients talk to local server, one server is leader
![client-server](images/nomad-architecture-region-a5b20915.png)
https://nomadproject.io/docs/internals/architecture.html

!SLIDE
# Architecture
![data model](images/nomad-data-model-39de5cfc.png)
https://nomadproject.io/docs/internals/scheduling.html

!SUB
# Terminology
* Job, Task & Taskgroup
* Allocation & Evaluation
* Node, Agent, Server & Client
* Taskdriver

!SLIDE
# Workshop goal
Exploring Nomad's features, pros, cons and it's future possibilities.

!SUB
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

!SLIDE
## Lets get started
To get started, fire up all VMs:

```
$ vagrant up
Bringing machine 'ddd-01' up with 'virtualbox' provider...
Bringing machine 'ddd-02' up with 'virtualbox' provider...
Bringing machine 'ddd-03' up with 'virtualbox' provider...
==> ddd-01: Importing base box 'dutchdockerday'...
==> ddd-01: Setting the name of the VM: vagrant_ddd-01_1446721417631_30468
==> ddd-01: Preparing network interfaces based on configuration...
==> ddd-01: Forwarding ports...
==> ddd-01: Running 'pre-boot' VM customizations...
==> ddd-01: Booting VM...
==> ddd-01: Waiting for machine to boot. This may take a few minutes...
    ddd-01: SSH address: 127.0.0.1:2222
    ddd-01: SSH username: vagrant
    ddd-01: SSH auth method: private key
    ddd-01: Warning: Connection timeout. Retrying...
==> ddd-01: Machine booted and ready!
==> ddd-01: Setting hostname...
==> ddd-01: Configuring and enabling network interfaces...
==> ddd-01: Rsyncing folder: /home/bbakker/sources/github/public/ddd-nomad/vagrant/ => /vagrant
==> ddd-01: Running provisioner: shell...
    ddd-01: Running: /tmp/vagrant-shell20151105-18494-1imtuhi.sh
...
```

!SUB
# Logging in
You can switch to root user without password.

```
$ vagrant ssh ddd-01

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
You have mail.
Last login: Thu Nov  5 11:13:23 2015 from 10.0.2.2
vagrant@ddd-01:~$ sudo su -
root@ddd-01:~#
```

!SUB
# Nomad command line
Does **not** need root, except for 'nomad agent'.

```
vagrant@ddd-01:~$ nomad
usage: nomad [--version] [--help] <command> [<args>]

Available commands are:
    agent                 Runs a Nomad agent
    agent-info            Display status information about the local agent
    alloc-status          Display allocation status information and metadata
    client-config         View or modify client configuration details
    eval-monitor          Monitor an evaluation interactively
    init                  Create an example job file
    node-drain            Toggle drain mode on a given node
    node-status           Display status information about nodes
    run                   Run a new job or update an existing job
    server-force-leave    Force a server into the 'left' state
    server-join           Join server nodes together
    server-members        Display a list of known servers and their status
    status                Display status information about jobs
    stop                  Stop a running job
    validate              Checks if a given job specification is valid
    version               Prints the Nomad version
```

https://nomadproject.io/docs/commands/index.html

!SUB
# Agent Dev Mode
In dev mode a single node is started that acts as both client and server.
This should not be used in production, we will do a proper setup afterwards.

!SUB
```
vagrant@ddd-01:~$ sudo nomad agent -dev
==> Starting Nomad agent...
2015/11/05 11:12:22 [ERR] fingerprint.env_aws: Error querying AWS Metadata URL, skipping
==> Nomad agent configuration:
Atlas: <disabled>
Client: true
Log Level: DEBUG
Region: global (DC: dc1)
Server: true

==> Nomad agent started! Log data will stream in below:
11:12:20 [INFO] serf: EventMemberJoin: ddd-01.global 127.0.0.1
11:12:20 [INFO] nomad: starting 1 scheduling worker(s) for [service batch _core]
11:12:20 [INFO] client: using alloc directory /tmp/NomadClient785630726
11:12:20 [INFO] raft: Node at 127.0.0.1:4647 [Follower] entering Follower state
11:12:20 [INFO] nomad: adding server ddd-01.global (Addr: 127.0.0.1:4647) (DC: dc1)
11:12:22 [INFO] raft: Disabling EnableSingleNode (bootstrap)
11:12:22 [DEBUG] raft: Node 127.0.0.1:4647 updated peer set (2): [127.0.0.1:4647]
11:12:22 [INFO] nomad: cluster leadership acquired
```

!SUB
# Exercises

* What is the status of the Nomad agent?
* Which server members are present?
* Which clients are present?
* which resources (CPU, memory, etc.) are available? ...
* which other information is available?

https://nomadproject.io/docs/agent/

!SUB
# Answers

```
$ nomad agent-info
$ nomad server-members
$ nomad node-status
```

Resources can't be queried with the CLI.   
Use HTTP API instead:

```
$ curl http://127.0.0.1:4646/v1/node/21eac115-f6ce-9357-9886cf058e4d | jq .
```

https://nomadproject.io/docs/http/nodes.html

!SLIDE
# Your first job
Let Nomad create an example job for you

```
$ nomad init
Example job file written to example.nomad
```

Starting the job:

```
vagrant@ddd-01:~$ nomad run example.nomad
==> Monitoring evaluation "6776c250-1a86-a6bf-050b-53d36dde4817"
Evaluation triggered by job "example"
Allocation "fb300253-e535-bb23-a3a7-6c16c09aab0c" created: node "9d4d05d1-468b-db71-fd8a-fb0bfc0cce1f", group "cache"
Evaluation status changed: "pending" -> "complete"
==> Evaluation "6776c250-1a86-a6bf-050b-53d36dde4817" finished with status "complete"
vagrant@ddd-01:~$ docker ps
CONTAINER ID   IMAGE           COMMAND                  CREATED         STATUS          PORTS                       
369d722e48f2   redis:latest    "/entrypoint.sh redis"   2 minutes ago   Up 2 minutes    10.0.2.15:37912->6379/tcp
```

!SUB
# Exercises
* See what you can find out about the Node, Evaluation and Allocation
* Try the HTTP API too!
* What happens if you kill the redis server with:

```
sudo killall redis-server
```

!SLIDE
# Running in Cluster
For a reliable cluster we need 3 servers (or 5). The Nomad configuration for running as a server is already supplied in `/etc/nomad.d/`.
Particularly note 'node.hcl', which is generated per node:

```
name="ddd-01"
bind_addr="172.17.8.101"
```

Nomad needs to bind to the local network rather than loopback or else the ndes cannot see eachother.

Use `export NOMAD_ADDR=http://ddd-01:4646` to let the nomad CLI connect to the right address.

```
vagrant@ddd-01:~$ sudo service nomad start
vagrant@ddd-01:~$ sudo service nomad status
● nomad.service - Nomad Agent
   Loaded: loaded (/etc/systemd/system/nomad.service; disabled)
   Active: active (running) since Wed 2015-11-11 02:13:49 UTC; 3s ago
 Main PID: 2745 (nomad)
   CGroup: /system.slice/nomad.service
           └─2745 /usr/bin/nomad agent -config=/etc/nomad.d

Server: true
==> Nomad agent started! Log data will stream in below:
2015/11/11 02:13:49 [INFO] serf: EventMemberJoin: ddd-01.global 172.17.8.101
2015/11/11 02:13:49 [INFO] nomad: starting 1 scheduling worker(s) for [service batch]
2015/11/11 02:13:49 [INFO] raft: Node at 172.17.8.101:4647 [Follower] entering Follower state
raft: Node at 172.17.8.101:4647 [Follower] entering Follower state
2015/11/11 02:13:49 [INFO] nomad: adding server ddd-01.global (Addr: 172.17.8.101:4647) (DC: dc1)
nomad: adding server ddd-01.global (Addr: 172.17.8.101:4647) (DC: dc1)
raft: EnableSingleNode disabled, and no known peers. Aborting election.
2015/11/11 02:13:50 [WARN] raft: EnableSingleNode disabled, and no known peers. Aborting election.
```

# Creating the cluster

* Login to all ddd-01, ddd-02 and ddd-03 and start nomad services.
* Check the cluster state. (Spoiler: you will )



!SLIDE
# Job creation
Nomad supports several job types:
  * Service
  * Batch
  * System(in a future release)

!SUB
# Task drivers
Docker can use several task drivers:
  * Docker
  * exec / raw_exec
  * java
  * there are others ...

!SLIDE
# Constraints
* Try to place your job based on metadata
* Try to place your job based on attribute

!SUB
# Job config
* Configure the job with environment variables

!SUB
# Updating jobs
* What happens if we change the version?
* What happens if we scale up/down?
* What happens if we add a constraint?

!SLIDE
# Node Management
* What happens if we add nodes?
* When we drain a node. What happens with jobs?
* What happens if we remove a node?

!SLIDE
# Failures
What happens if...
* We kill job?
* We kill a Nomad client?
* We kill a Nomad server?
* We kill a VM?
* We restart after all Nomad servers went down?
* We exhaust the resources on a node?

*Are resource limits hard? How are they enforced? Via Docker resource limits? Via cgroups in 'exec' driver?*

!SLIDE
# What will the future bring?
Nomad is being actively developed and new features are being merged constantly.
