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
