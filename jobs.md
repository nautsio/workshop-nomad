# Jobs
This section will take a look at the different types of jobs that Nomad supports, specifying constraints for a job and modifying jobs at runtime.

!SUB
# Job types
Nomad supports several job types:
  * **Service**: The service scheduler is designed for scheduling long lived services that should never go down.
  * **Batch**: Batch jobs are much less sensitive to short term performance fluctuations and are short lived, finishing in a few minutes to a few days.
  * **System**: The system scheduler is used to register jobs that should be run on all clients that meet the job's constraints.

!SUB
# Task drivers
Nomad can use several task drivers:
  * Docker - run a Docker container
  * exec/rawexec - execute a (downloaded) executable, in its own chroot and cgroup (on Linux)
  * java - run a downloaded Java jar file
  * there are others ...

!SLIDE
# Job creation
Lets start by creating a job of our own, in JSON format so we can send it to the HTTP API endpoint of Nomad.
We have pre-pulled some images (take a look at `docker images`) now we need to create the job file for one of them.

**Exercises**
* Create a minimal job for the selected docker image.
* Start the job by sending it to the Nomad `/v1/jobs` HTTP API endpoint.

https://nomadproject.io/docs/jobspec/index.html

!SUB
# Constraints
By specifying constraints you can dictate a set of rules that Nomad will follow when placing your jobs. These constraints can be on resources, self applied metadata and other configured attributes.

**Exercises**
* Try to place the job based on a node's attribute (e.g. hostname)
* Try to place the job based on a node's metadata (We will need to add some)

!SUB
# Restart policies
Very few tasks are immune to failure and the addition of restart policies recognizes that and allows users to rely on Nomad to keep the task running through transient failures.

**Exercises**
* Add a restart policy to the job.
* Kill one of the job instances by executing the   
`docker kill <job>` command.

!SUB
# Updating jobs
Now lets try changing settings in the job file and see what happens when we resubmit the job.

**Questions**
* What happens if we change the version?
* What happens if we scale up/down?
* What happens if we add a constraint that would disallow placement of the already placed job?

!SUB
# Service discovery

Since verson 0.2.0 Nomad now integrates directly with Consul for its service discovery, which removes the need for a separate Registrator container.

Lets see this new feature in action by adding service discovery to our client nodes and job files.

!SUB
# Service discovery

**Exercises**
* Add

  ```
  consul {
    address = "<hostname>:8500"
  }
  ```
  to the client section of the Nomad node configurations.
* Restart the Nomad services.
* Add a service block to the job specification.
* Resubmit the job and check if it appears in consul:   
`curl http://ddd-01:8500/v1/catalog/services | jq .`

https://nomadproject.io/docs/jobspec/servicediscovery.html

!SUB
# System scheduler
Another new feature is the System scheduler, which will make sure your application is running on every node that matches the specified constraints.

**Exercises**
* Change the job type to system. What does this do to the job placement? (If we still have the hostname constraint, not a lot will happen...)

https://nomadproject.io/docs/jobspec/schedulers.html
