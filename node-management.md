# Node Management
* What happens if we add nodes?
* When we drain a node. What happens with jobs?
* What happens if we remove a node?

!SUB
# Node Management
* Added nodes will show up in `nomad node-status`. New allocations may be scheduled on the new node.
* To drain a node Nomad will fire up instances on remaining nodes and kill off the jobs
 on the drained node.

!SLIDE
# Resource Management

Nomad will only schedule jobs on a node if that will not exceed its resource capacity.



Therefore Nomad task
