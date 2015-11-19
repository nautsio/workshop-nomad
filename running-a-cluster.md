# Running a Nomad Cluster
For a reliable cluster we need 3 servers or 5. More is possible but will make reaching consensus slower.

So let's start it on all our servers.

The Nomad configuration for running as a server is already supplied in `/etc/nomad.d/`,
as 'Hashicorp Configuration Language' files.

HCL is an extension of JSON, see https://github.com/hashicorp/hcl/blob/master/README.md

!SUB
# Binding to the right address
Particularly note 'node.hcl', which is generated per node by Vagrant:

```
name="ddd-01"
bind_addr="172.17.8.101"
```

Nomad needs to bind to the local network rather than loopback or else the nodes cannot see eachother.

Use `export NOMAD_ADDR=http://ddd-01:4646` to let the nomad CLI connect to the right address.

!SUB
# Starting the agent as as service

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

!SUB

# Creating the cluster
* Login to all ddd-01, ddd-02 and ddd-03 and start Nomad services.
* Check the cluster state. (Spoiler: no cluster yet)

!SUB
# Creating the cluster
The Nomad services run but do not know eachother yet.

They need to 'join'.

Exercise:
* let ddd-02 join ddd-01 and ddd-03 join ddd-02
* check the cluster state
* who is leader?

!SUB
# Results

On node 1, join 2:

```
vagrant@ddd-01:~$ export NOMAD_ADDR=http://ddd-01:4646
vagrant@ddd-01:~$ nomad server-members
Name           Addr          Port  Status  Proto  Build  DC   Region
ddd-01.global  172.17.8.101  4648  alive   2      0.1.2  dc1  global
vagrant@ddd-01:~$ nomad server-join 172.17.8.102
Joined 1 servers successfully
vagrant@ddd-01:~$ nomad server-members
Name           Addr          Port  Status  Proto  Build  DC   Region
ddd-01.global  172.17.8.101  4648  alive   2      0.1.2  dc1  global
ddd-02.global  172.17.8.102  4648  alive   2      0.1.2  dc1  global
```

!SUB
# Results

One node 3, join 2:

```
vagrant@ddd-03:~$ export NOMAD_ADDR=http://ddd-03:4646
vagrant@ddd-03:~$ nomad server-join ddd-02
Joined 1 servers successfully
```

See results:

```
vagrant@ddd-01:~$ nomad server-members
Name           Addr          Port  Status  Proto  Build  DC   Region
ddd-01.global  172.17.8.101  4648  alive   2      0.1.2  dc1  global
ddd-02.global  172.17.8.102  4648  alive   2      0.1.2  dc1  global
ddd-03.global  172.17.8.103  4648  alive   2      0.1.2  dc1  global

vagrant@ddd-03:~$ curl $NOMAD_ADDR/v1/status/leader
"172.17.8.102:4647"
```

!SUB
# Running a job in the cluster

Now try to run a job.

What happens?

Why?

!SUB
# Running a job in the cluster

Probably you saw something like this:

```
vagrant@ddd-01:~$ nomad run example.nomad
==> Monitoring evaluation "ccdd0603-68ef-5c6c-46f4-02dfe9c4ac2e"
    Evaluation triggered by job "example"
    Scheduling error for group "cache" (failed to find a node for placement)
    Allocation "a8a01dcd-b849-379f-8fab-437c51319105" status "failed" (0/0 nodes filtered)
      * No nodes were eligible for evaluation
    Evaluation status changed: "pending" -> "complete"
==> Evaluation "ccdd0603-68ef-5c6c-46f4-02dfe9c4ac2e" finished with status "complete"
```

*`failed to find a node`* Our cluster consists of servers, but has no clients yet.

!SUB
# Adding clients

So we need to add one or more 'clients'. Note that Nomad uses the term 'node' and 'client' interchangeably.

Typically your cluster has 3 or 5 dedicated Nomad servers and many Nomad clients. Here, we will let our
VMs double as both client and server.

At a minimum a the configuration needs to enable the client role and the list of servers.

```
client {
  enabled = true
  servers = ["ddd-01:4646", "ddd-02:4646", "ddd-03:4646"]
}
```

!SUB
# Adding clients

To get you going we have provided the necessary configuration in `/etc/nomad.d/client.hcl.off`.

Rename it and restart Nomad.

`nomad node-status` should now list the clients:

```
vagrant@ddd-01:~$ nomad node-status
ID                                    DC   Name    Class   Drain  Status
496ac358-b1ae-d287-dd97-8c8e0ff12e22  dc1  ddd-01  <none>  false  ready
1c415080-0219-da83-c181-b38a9f4dc30d  dc1  ddd-02  <none>  false  ready
```

`nomad node-status <node-id>` also returns allocations, and the rest endpoint will return even more information.
