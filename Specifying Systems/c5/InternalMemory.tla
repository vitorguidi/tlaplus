--------------------------- MODULE InternalMemory ---------------------------
EXTENDS MemoryInterface
(* will have access to MemoryInterface variables by doing this extend *)
VARIABLES mem, ctl, buf

-----------------------------------------------------------------------------
IInit ==
    /\ mem \in [Adr -> Val] (* mem is any of the possible els in set of functions that take 
                               values in Adr as argument and map to any value in Val     *)
    /\ ctl = [p \in  Proc |-> "rdy"] (* the function that maps all els in Proc to rdy *)
    /\ buf = [p \in Proc |-> NoVal]  (* ditto. once concrete function *)
    /\ memInt \in InitMemInt
    
(* pay attention to difference between single function and el that belongs to set of functions *)    
TypeInvariant ==
    /\ mem \in [Adr -> Val] 
    /\ ctl \in [Proc -> {"rdy", "busy", "done"}]
    /\ buf \in [Proc -> {NoVal} \union MReq \union Val]
    
Req(p) ==
    /\ ctl[p] = "rdy" 
    /\ \E req \in MReq:
        /\ Send(p, req, memInt, memInt')
        /\ buf' = [buf EXCEPT ![p] = req]
        /\ ctl' = [ctl EXCEPT ![p] = "busy"]
    /\ UNCHANGED mem
    
Do(p) ==
    /\ ctl[p] = "busy"
    /\ mem' = IF buf[p].op = "Wr"
                THEN [mem EXCEPT ![buf[p].adr] = buf[p].val]    (* if writing, move data from buff to mem *)
                ELSE mem                                        (* if reading, mem does not change *)
    /\ buf' = [buf EXCEPT ![p] = 
                IF buf[p].op = "Wr" THEN NoVal  (* if writing, we empty out buffer for said process *)
                ELSE mem[buf[p].adr]]           (* if reading, we move value from memory to buffer*)
                
    /\ ctl' = [ctl EXCEPT ![p] = "done"]
    /\ UNCHANGED memInt
    
Rsp(p) ==
    /\ ctl[p] = "done"
    /\ Reply(p, buf[p], memInt, memInt')
    /\ ctl' = [ctl EXCEPT ![p] = "rdy"]
    /\ UNCHANGED <<mem,buf>>
    
INext == \E p \in Proc : Req(p) \/ Do(p) \/ Rsp(p)
  
ISpec == IInit /\ [][INext]_<<memInt, mem, ctl, buf>>
  
-----------------------------------------------------------------------------
                       
THEOREM ISpec => []TypeInvariant
=============================================================================
\* Modification History
\* Last modified Fri Jun 23 09:04:01 BRT 2023 by vguidi
\* Created Thu Jun 22 03:01:21 BRT 2023 by vguidi
