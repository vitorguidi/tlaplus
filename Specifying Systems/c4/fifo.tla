-------------------------------- MODULE fifo --------------------------------
EXTENDS Naturals, Sequences

CONSTANT Messages, BufferLimit
VARIABLES in, out, q

SenderChan == INSTANCE channel WITH Data <- Messages, chan <- in
ReceiverChan == INSTANCE channel WITH Data <- Messages, chan <- out
-----------------------------------------------------------------------------

Init == 
    /\ SenderChan!Init
    /\ ReceiverChan!Init
    /\ q = <<>>
    
TypeInvariant ==
    /\ SenderChan!TypeInvariant
    /\ ReceiverChan!TypeInvariant
    /\ q \in Seq(Messages)
    
 (* We already have enabling condition on the inside of the channels,
    so just use the interface *)
 (* Sender *)
SSend(m) ==
    /\ SenderChan!Send(m)
    /\ UNCHANGED<<out, q>>
    
BuffRcv ==
    /\ Len(q) < BufferLimit
    /\ q' = Append(q, in.val)
    /\ SenderChan!Receive
    /\ UNCHANGED out
    
BuffSend ==
    /\ q # <<>>
    /\ ReceiverChan!Send(Head(q))
    /\ q' = Tail(q)
    /\ UNCHANGED in
    
RRcv == 
    /\ ReceiverChan!Receive
    /\ UNCHANGED <<in, q>>
    
Next ==
    \/ (\E m \in Messages : SSend(m))
    \/ BuffRcv
    \/ BuffSend
    \/ RRcv
   
Spec == Init /\ [][Next]_<<in, out, q>>

-----------------------------------------------------------------------------
THEOREM Spec => TypeInvariant
=============================================================================
\* Modification History
\* Last modified Wed Jun 21 01:22:46 BRT 2023 by vguidi
\* Created Wed Jun 21 00:00:36 BRT 2023 by vguidi
