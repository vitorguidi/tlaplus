------------------------------ MODULE TwoPhase ------------------------------
CONSTANT RM
VARIABLES 
    rmState, 
    tmState,
    tmPrepared,
    msgs
-----------------------------------------------------------------------------

Messages == [type: {"Prepared"}, rm: RM] \cup [type: {"Commit", "Abort"}]
TPTypeOK == /\ rmState \in [RM -> {"working", "prepared", "commited", "aborted"}]
            /\ tmState \in {"init", "done"}
            /\ tmPrepared \subseteq RM
            /\ msgs \subseteq Messages

TPInit == /\ rmState = [r \in RM |-> "working"]
          /\ tmState = "init"
          /\ tmPrepared = {}
          /\ msgs = {}

TMRcvPrepared(r) ==
    /\ tmState = "init"
    /\ [type |-> "Prepared", rm |-> r] \in msgs
    /\ tmPrepared' = tmPrepared \cup {r}
    /\ UNCHANGED <<rmState, tmState, msgs>>

TMCommit == /\ tmState = "init"
            /\ RM \subseteq tmPrepared
            /\ tmState' = "done"
            /\ msgs' = msgs \cup {[type |-> "Commit"]}
            /\ UNCHANGED<<rmState, tmPrepared>>

TMAbort == /\ tmState = "init"
           /\ tmState' = "done"
           /\ msgs' = msgs \cup {[type |-> "Abort"]}
           /\ UNCHANGED<<rmState, tmPrepared>>

RMPrepare(r) == /\ rmState[r] = "working"
                /\ rmState' = [rmState EXCEPT ![r] = "prepared"]
                /\ msgs' = msgs \cup {[type |-> "Prepared", rm |-> r]}
                /\ UNCHANGED <<tmState, tmPrepared>>

RMChooseToAbort(r) == /\ rmState[r] = "working"
                      /\ rmState' = [rmState EXCEPT ![r] = "aborted"]
                      /\ UNCHANGED<<msgs,tmState,tmPrepared>>

RMRcvCommitMessage(r) == /\ \E msg \in msgs: msg=[type|->"Commit"]
                         /\ rmState' = [rmState EXCEPT ![r] = "commited"]
                         /\ UNCHANGED <<tmState,tmPrepared,msgs>>

RMRcvAbortMessage(r) == /\ \E msg \in msgs: msg=[type|->"Abort"]
                        /\ rmState' = [rmState EXCEPT ![r] = "aborted"]
                        /\ UNCHANGED <<tmState,tmPrepared,msgs>>

TPNext ==
    \/ TMCommit 
    \/ TMAbort
    \/ \E r \in RM: TMRcvPrepared(r) \/ RMPrepare(r) \/ RMChooseToAbort(r)
        \/ RMRcvAbortMessage(r) \/ RMRcvCommitMessage(r)

=============================================================================
\* Modification History
\* Last modified Tue Jan 10 23:52:45 BRT 2023 by vitor
\* Created Tue Jan 10 16:11:14 BRT 2023 by vitor
