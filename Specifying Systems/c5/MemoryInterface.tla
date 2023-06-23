-------------------------- MODULE MemoryInterface --------------------------
VARIABLE memInt
CONSTANTS Send(_, _, _, _),
          Reply(_, _, _, _),
          InitMemInt,
          Proc,
          Adr,
          Val

(*
    We are defining an interface, so the inner workings should be left abstract
    In TLA we do not have variables for actions/functions, so we make Send, Reply and InitMemInt
    constants in order to instantiate them with expressions of our liking
*)

ASSUME \A p, d, miOld, miNew: 
    /\  Send(p, d, miOld, miNew) \in BOOLEAN
    /\  Reply(p, d, miOld, miNew) \in BOOLEAN
    
-----------------------------------------------------------------------------
MReq ==
    [op: {"Rd"}, adr: Adr] \UNION [op: {"Wr"}, adr: Adr, val: Val]

NoVal ==
    CHOOSE v : v \notin Val
=============================================================================
\* Modification History
\* Last modified Thu Jun 22 01:40:59 BRT 2023 by vguidi
\* Created Thu Jun 22 01:30:13 BRT 2023 by vguidi
