----------------------------- MODULE telephone -----------------------------
EXTENDS Sequences, TLC
(*--algorithm telephone
variables
    (* how the hell do we iterate over sequences *)
    buffer = {}, 
    sender = <<1,2,3>>,
    receiver = <<>>;
    can_send = TRUE;
begin
    while Len(receiver) # 3 do
        if can_send /\ sender # <<>> then
            buffer := buffer \union {Head(sender)};
            can_send := FALSE;
            sender := Tail(sender);
        end if;
        
        either
            with msg \in buffer do
                receiver := Append(receiver, msg);
                buffer := buffer \ {msg};
                either
                   can_send := TRUE;
                or
                   skip;
                end either;
            end with;
        or
            skip;
        end either;
    end while; 
assert receiver = <<1,2,3>>;
end algorithm; *)
\* BEGIN TRANSLATION (chksum(pcal) = "fa932d8a" /\ chksum(tla) = "682cd5e4")
VARIABLES buffer, sender, receiver, can_send, pc

vars == << buffer, sender, receiver, can_send, pc >>

Init == (* Global variables *)
        /\ buffer = {}
        /\ sender = <<1,2,3>>
        /\ receiver = <<>>
        /\ can_send = TRUE
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF Len(receiver) # 3
               THEN /\ IF can_send /\ sender # <<>>
                          THEN /\ buffer' = (buffer \union {Head(sender)})
                               /\ can_send' = FALSE
                               /\ sender' = Tail(sender)
                          ELSE /\ TRUE
                               /\ UNCHANGED << buffer, sender, can_send >>
                    /\ \/ /\ pc' = "Lbl_2"
                       \/ /\ TRUE
                          /\ pc' = "Lbl_1"
               ELSE /\ Assert(receiver = <<1,2,3>>, 
                              "Failure of assertion at line 32, column 1.")
                    /\ pc' = "Done"
                    /\ UNCHANGED << buffer, sender, can_send >>
         /\ UNCHANGED receiver

Lbl_2 == /\ pc = "Lbl_2"
         /\ \E msg \in buffer:
              /\ receiver' = Append(receiver, msg)
              /\ buffer' = buffer \ {msg}
              /\ \/ /\ can_send' = TRUE
                 \/ /\ TRUE
                    /\ UNCHANGED can_send
         /\ pc' = "Lbl_1"
         /\ UNCHANGED sender

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 
=============================================================================
\* Modification History
\* Last modified Tue Jun 13 23:16:24 BRT 2023 by vguidi
\* Created Tue Jun 13 17:50:09 BRT 2023 by vguidi
