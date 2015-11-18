# Job creation
Nomad supports several job types:
  * Service
  * Batch
  * System (in a future release)

Current Nomad releases focus improving the experience for Service jobs.

Batch and System are on the roadmap for 0.3 and up.

!SUB
# Task drivers
Docker can use several task drivers:
  * Docker - run a Docker container
  * exec - execute a (downloaded) executable, in its own chroot and cgroup (on Linux)
  * java - run a downloaded Java jar.
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
