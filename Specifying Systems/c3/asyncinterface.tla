---------------------- MODULE asyncinterface ----------------------
EXTENDS Naturals
VARIABLES val, rdy, ack
CONSTANT Data

TypeInvariant == 
    /\  val \in Data
    /\  rdy \in {0,1}
    /\  ack \in {0,1}

---------------------------------------------------------------

Init ==
    /\ val \in Data
    /\ ack \in {0,1}
    /\ rdy = ack
    

(* 
    Gotta define symbols in the order of evaluation
    if I write rdy = ack, then UNCHANGED ack, it will complain ack is not defined
*)

Send ==
    /\ UNCHANGED ack
    /\ rdy = ack
    /\ rdy' = 1 - rdy
    /\ val' \in Data
    
Receive ==
    /\ rdy # ack
    /\ ack' = 1 - ack
    /\ UNCHANGED <<rdy,val>>
    
Next ==
    \/ Send
    \/ Receive
    
Spec ==
    Init /\ [][Next]_<<val,rdy,ack>>

(* 
    can send if rdy == ack. send flips rdy
    can rcv if rdy != ack. rcv flips ack
*)

--------------------------------------------------------------
THEOREM Spec => TypeInvariant
==============================================================