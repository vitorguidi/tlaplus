---------------------- MODULE channel ----------------------
EXTENDS Naturals
VARIABLES chan
CONSTANT Data

TypeInvariant ==
    chan \in [ack: {0,1}, rdy: {0,1}, val: Data]
--------------------------------------------------------------

Init == 
    /\ TypeInvariant
    /\ chan.rdy = chan.ack
    
Send(d) ==
    /\ chan.rdy = chan.ack
    /\ chan' = [chan EXCEPT !.rdy = 1 - @, !.val = d]
    
Receive ==
    /\ chan.rdy # chan.ack
    /\ chan' = [chan EXCEPT !.ack = 1 - @]
    
Next ==
    \/ \E d \in Data : Send(d)
    \/ Receive
    
Spec ==
    Init /\ [][Next]_chan

--------------------------------------------------------------
THEOREM Spec => TypeInvariant
==============================================================