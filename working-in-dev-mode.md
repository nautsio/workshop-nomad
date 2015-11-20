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
# Agent Dev Mode

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

NB. The error messagee about Consul can be safely ignore.

!SUB
# Exercises

* What is the status of the Nomad agent?
* Which server members are present?
* Which clients are present?
* what resources (CPU, memory, etc.) are available? ...
* what other information is available?

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
