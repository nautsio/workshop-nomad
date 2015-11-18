# Architecture
Clients talk to local server, one server is leader
![client-server](images/nomad-architecture-region-a5b20915.png)
https://nomadproject.io/docs/internals/architecture.html

!SUB
# Architecture
![data model](images/nomad-data-model-39de5cfc.png)
https://nomadproject.io/docs/internals/scheduling.html

!SUB
# Terminology
* Job, Task & Taskgroup
  A Job is a specification of tasks that Nomad should run.
  It consists of Taskgroups, which themselves contain one ore more Tasks.
* Allocation
  An Allocation is a placement of a Task on a machine.
* Evaluation
  An Evaluation is a determination where a Job can be run.  
* Node, Agent, Server & Client
* Task Driver
