# What is Nomad
* Nomad is a resource manager
* Scheduler for multiple workloads
  - Docker
  - exec process
  - Java
  - Qemu VM
* Single binary
* Multi-Datacenter
* Very new. version 0.1.3
XXX

!SUB
# Architecture overview
* terminology:
  - job
  - task, taskgroup
  - allocation
  - evalutation
  - node
  - agent
  - server
  - client
  - task_driver
XXX

!SLIDE
# Workshop goal
XXX

!SUB
# Workshop Setup
Prerequisites:
* Virtualbox
* Vagrant
* Enough memory
* This project repo

!SUB
## Environment
The workshop environment consists of 3 VMs running Debian Jessie.
They have Docker, Nomad, Consul and collectd preinstalled.
Configuration still to be done by you.

!SUB
## collectd
Collectd will gather metrics on the VMs, Nomad and Consul and send
them to XXX.
XXX how to find your IDs and lookup your metrics

!SLIDE
## Starting
To get started, fire up all VMs:

```
$ vagrant up
Bringing machine 'ddd-01' up with 'virtualbox' provider...
Bringing machine 'ddd-02' up with 'virtualbox' provider...
Bringing machine 'ddd-03' up with 'virtualbox' provider...
==> ddd-01: Importing base box 'dutchdockerday'...
==> ddd-01: Matching MAC address for NAT networking...
==> ddd-01: Setting the name of the VM: vagrant_ddd-01_1446721417631_30468
==> ddd-01: Clearing any previously set network interfaces...
==> ddd-01: Preparing network interfaces based on configuration...
    ddd-01: Adapter 1: nat
    ddd-01: Adapter 2: hostonly
==> ddd-01: Forwarding ports...
    ddd-01: 22 => 2222 (adapter 1)
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
You can switch to root user without password (it is 'vagrant' btw)

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

!SUB
# Agent Dev Mode

* starts a single node in dev mode.
* acts both as client and server
* NOT for production we will perform a proper server installation later

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

    2015/11/05 11:12:20 [INFO] serf: EventMemberJoin: ddd-01.global 127.0.0.1
    2015/11/05 11:12:20 [INFO] nomad: starting 1 scheduling worker(s) for [service batch _core]
    2015/11/05 11:12:20 [INFO] client: using alloc directory /tmp/NomadClient785630726
    2015/11/05 11:12:20 [INFO] raft: Node at 127.0.0.1:4647 [Follower] entering Follower state
    2015/11/05 11:12:20 [INFO] nomad: adding server ddd-01.global (Addr: 127.0.0.1:4647) (DC: dc1)
    2015/11/05 11:12:22 [WARN] raft: Heartbeat timeout reached, starting election
    2015/11/05 11:12:22 [INFO] raft: Node at 127.0.0.1:4647 [Candidate] entering Candidate state
    2015/11/05 11:12:22 [DEBUG] raft: Votes needed: 1
    2015/11/05 11:12:22 [DEBUG] raft: Vote granted. Tally: 1
    2015/11/05 11:12:22 [INFO] raft: Election won. Tally: 1
    2015/11/05 11:12:22 [INFO] raft: Node at 127.0.0.1:4647 [Leader] entering Leader state
    2015/11/05 11:12:22 [INFO] raft: Disabling EnableSingleNode (bootstrap)
    2015/11/05 11:12:22 [DEBUG] raft: Node 127.0.0.1:4647 updated peer set (2): [127.0.0.1:4647]
    2015/11/05 11:12:22 [INFO] nomad: cluster leadership acquired
    2015/11/05 11:12:22 [DEBUG] client: applied fingerprints [arch cpu host memory storage network]
    2015/11/05 11:12:22 [DEBUG] client: available drivers [docker exec java]
    2015/11/05 11:12:22 [DEBUG] client: node registration complete
    2015/11/05 11:12:22 [DEBUG] client: updated allocations at index 1 (0 allocs)
    2015/11/05 11:12:22 [DEBUG] client: allocs: (added 0) (removed 0) (updated 0) (ignore 0)
    2015/11/05 11:12:22 [DEBUG] client: state updated to ready
```


```
nomad agent-info
nomad status
nomad node-status
nomad alloc-status
nomad server-members
```
XXX

!SUB
# Start your first job
Create an example job

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
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                       NAMES
369d722e48f2        redis:latest        "/entrypoint.sh redis"   2 minutes ago       Up 2 minutes        10.0.2.15:37912->6379/tcp   reverent_bose
```

!SLIDE
# Running in Cluster
For a reliable cluster we need 3 servers (or 5).

Nomad configuration for running as a server is already supplied in `/etc/nomad.d/`.
Configuration uses HCL format, see XX for details.

Systemd unit file is also installed, so starting as a service is simple

```
vagrant@ddd-01:~$ sudo service nomad start
vagrant@ddd-01:~$ sudo service nomad status
● nomad.service - Nomad Agent
   Loaded: loaded (/etc/systemd/system/nomad.service; disabled)
   Active: active (running) since Thu 2015-11-05 12:33:31 UTC; 3s ago
 Main PID: 2045 (nomad)
   CGroup: /system.slice/nomad.service
           └─2045 /usr/bin/nomad agent -config=/etc/nomad.d

Nov 05 12:33:31 ddd-01 nomad[2045]: raft: Node at 172.17.8.101:4647 [Follower] entering Follower state
Nov 05 12:33:31 ddd-01 nomad[2045]: 2015/11/05 12:33:31 [INFO] raft: Node at 172.17.8.101:4647 [Follower] entering Follower state
Nov 05 12:33:31 ddd-01 nomad[2045]: 2015/11/05 12:33:31 [INFO] serf: Attempting re-join to previously known node: ddd-01.amsterdam: 172.17.8.101:4648
Nov 05 12:33:31 ddd-01 nomad[2045]: serf: Attempting re-join to previously known node: ddd-01.amsterdam: 172.17.8.101:4648
Nov 05 12:33:31 ddd-01 nomad[2045]: 2015/11/05 12:33:31 [INFO] nomad: adding server ddd-01.global (Addr: 172.17.8.101:4647) (DC: dc1)
Nov 05 12:33:31 ddd-01 nomad[2045]: nomad: adding server ddd-01.global (Addr: 172.17.8.101:4647) (DC: dc1)
Nov 05 12:33:31 ddd-01 nomad[2045]: serf: Re-joined to previously known node: ddd-01.amsterdam: 172.17.8.101:4648
Nov 05 12:33:31 ddd-01 nomad[2045]: 2015/11/05 12:33:31 [INFO] serf: Re-joined to previously known node: ddd-01.amsterdam: 172.17.8.101:4648
Nov 05 12:33:32 ddd-01 nomad[2045]: raft: EnableSingleNode disabled, and no known peers. Aborting election.
Nov 05 12:33:32 ddd-01 nomad[2045]: 2015/11/05 12:33:32 [WARN] raft: EnableSingleNode disabled, and no known peers. Aborting election.
```

# Job creation
## Job Types:
  * Service
  * Batch
  * System(?)
## Task drivers
  * Docker
  * exec / raw_exec
    *
  * there are others ...

# Constraints
## Node selection on metadata
## Node selection on node class

# Job config via options
## ENV setting for docker container, e.g. output message of paas-monitor
## port mappings

# Updating jobs
## Scaling up & down
## Rolling updates

# Node Management
## Node availability
## Adding nodes.
## draining nodes. What happens with jobs?
## removing nodes.
## Resource usage / availability

# Failures
# Kill job / container
# Kill Nomad client
# Kill VM
# Kill Server
## Leadership election. WHat happens if #servers < bootstrap
## Restart after all Nomad servers down
# Resource exhaustion
## How detected, resolved...
## Are resource limits hard? How enforced? Via Docker resource limits? Via cgroups in 'exec' driver?
