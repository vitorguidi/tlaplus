------------------------------- MODULE TCommit ------------------------------
CONSTANT RM       \* The set of participating resource managers
VARIABLE rmState  \* `rmState[rm]' is the state of resource manager rm.
-----------------------------------------------------------------------------

TCTypeOK == 
    rmState \in [RM -> {"working", "prepared", "commited", "aborted"}]

TCConsistent ==
    \A rm1, rm2 \in RM: ~ /\ rmState[rm1] = "commited"
                          /\ rmState[rm2] = "aborted"

TCInit == rmState = [rm \in RM |-> "working"]

notCommited == \A rm \in RM : rmState[rm] # "commited"

canCommit == \A rm \in RM : rmState[rm] \in {"prepared", "commited"}

TCPrepare(rm) == /\ rmState[rm] = "working"
                 /\ rmState' = [rmState EXCEPT ![rm] = "prepared"]

TCDecide(rm) == \/ /\ rmState[rm] = "prepared"
                   /\ canCommit
                   /\ rmState' = [rmState EXCEPT ![rm] = "commited"]
                \/ /\ rmState[rm] \in {"prepared", "working"}
                   /\ notCommited
                   /\ rmState' = [rmState EXCEPT ![rm] = "aborted"]

TCNext == \E rm \in RM : TCPrepare(rm) \/ TCDecide(rm)
    

=============================================================================
