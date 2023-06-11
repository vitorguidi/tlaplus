-------------------------------- MODULE wire --------------------------------
EXTENDS Integers
(*--algorithm wire
variables
    people = {"alice","bob"},
    acc = [p \in people |-> 5];


define
    NoOverdrafts == \A p \in people: acc[p]>=0
end define;    

process Wire \in 1..2
    variables
        sender = "alice";
        receiver = "bob";
        amount \in 1..acc[sender];
begin
    Transaction:
        if amount <= acc[sender] then
            acc[sender] := acc[sender] - amount;
        end if;
    (* 
      Apparently every atomic code block must have a label
      I cannot just ignore the deposit label here
      Quoting lamport:  A single
      step (atomic action) of a PlusCal algorithm consists of the execution from
      one label to the next.
    *)
    Deposit:
        acc[receiver] := acc[receiver] + amount;
end process
end algorithm;*)
\* BEGIN TRANSLATION (chksum(pcal) = "346fd3b3" /\ chksum(tla) = "dc0a5da0")
VARIABLES people, acc, pc

(* define statement *)
NoOverdrafts == \A p \in people: acc[p]>=0

VARIABLES sender, receiver, amount

vars == << people, acc, pc, sender, receiver, amount >>

ProcSet == (1..2)

Init == (* Global variables *)
        /\ people = {"alice","bob"}
        /\ acc = [p \in people |-> 5]
        (* Process Wire *)
        /\ sender = [self \in 1..2 |-> "alice"]
        /\ receiver = [self \in 1..2 |-> "bob"]
        /\ amount \in [1..2 -> 1..acc[sender[CHOOSE self \in  1..2 : TRUE]]]
        /\ pc = [self \in ProcSet |-> "Transaction"]

Transaction(self) == /\ pc[self] = "Transaction"
                     /\ IF amount[self] <= acc[sender[self]]
                           THEN /\ acc' = [acc EXCEPT ![sender[self]] = acc[sender[self]] - amount[self]]
                           ELSE /\ TRUE
                                /\ acc' = acc
                     /\ pc' = [pc EXCEPT ![self] = "Deposit"]
                     /\ UNCHANGED << people, sender, receiver, amount >>

Deposit(self) == /\ pc[self] = "Deposit"
                 /\ acc' = [acc EXCEPT ![receiver[self]] = acc[receiver[self]] + amount[self]]
                 /\ pc' = [pc EXCEPT ![self] = "Done"]
                 /\ UNCHANGED << people, sender, receiver, amount >>

Wire(self) == Transaction(self) \/ Deposit(self)

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == /\ \A self \in ProcSet: pc[self] = "Done"
               /\ UNCHANGED vars

Next == (\E self \in 1..2: Wire(self))
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(\A self \in ProcSet: pc[self] = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Sun Jun 11 16:43:38 BRT 2023 by vguidi
\* Created Sun Jun 11 15:38:37 BRT 2023 by vguidi
