------------------------------ MODULE sorting ------------------------------
EXTENDS Sequences ,Integers, TLC, FiniteSets
(*--algorithm sorting
variables
    capacity \in [trash : 1..10, recycle : 1..10],
    \* bins must be a list. duplicate items in set get merged
    bins = [trash |-> <<>>, recycle |-> <<>>],
    count = [trash |-> 0, recycle |-> 0],
    item = [type: {"recycle", "trash"}, size: 1..6],
    items \in item \X item \X item \X item,
    curr="";
macro add_item(type) begin
 bins[type] := Append(bins[type], curr);
 capacity[type] := capacity[type] - curr.size;
 count[type] := count[type] + 1;
end macro;
begin
    while items # <<>> do
        curr := Head(items);
        items := Tail(items);
        if curr.type = "recycle" /\ curr.size < capacity.recycle then
            add_item("recycle");
        elsif curr.size < capacity.trash then
            add_item("trash");
        end if;
    end while;
assert capacity.trash >= 0 /\ capacity.recycle >=0;
assert Len(bins.trash) = count.trash;
assert Len(bins.recycle) = count.recycle;
end algorithm;*)
\* BEGIN TRANSLATION (chksum(pcal) = "f8af070e" /\ chksum(tla) = "d0ad2fe4")
VARIABLES capacity, bins, count, item, items, curr, pc

vars == << capacity, bins, count, item, items, curr, pc >>

Init == (* Global variables *)
        /\ capacity \in [trash : 1..10, recycle : 1..10]
        /\ bins = [trash |-> <<>>, recycle |-> <<>>]
        /\ count = [trash |-> 0, recycle |-> 0]
        /\ item = [type: {"recycle", "trash"}, size: 1..6]
        /\ items \in item \X item \X item \X item
        /\ curr = ""
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF items # <<>>
               THEN /\ curr' = Head(items)
                    /\ items' = Tail(items)
                    /\ IF curr'.type = "recycle" /\ curr'.size < capacity.recycle
                          THEN /\ bins' = [bins EXCEPT !["recycle"] = Append(bins["recycle"], curr')]
                               /\ capacity' = [capacity EXCEPT !["recycle"] = capacity["recycle"] - curr'.size]
                               /\ count' = [count EXCEPT !["recycle"] = count["recycle"] + 1]
                          ELSE /\ IF curr'.size < capacity.trash
                                     THEN /\ bins' = [bins EXCEPT !["trash"] = Append(bins["trash"], curr')]
                                          /\ capacity' = [capacity EXCEPT !["trash"] = capacity["trash"] - curr'.size]
                                          /\ count' = [count EXCEPT !["trash"] = count["trash"] + 1]
                                     ELSE /\ TRUE
                                          /\ UNCHANGED << capacity, bins, 
                                                          count >>
                    /\ pc' = "Lbl_1"
               ELSE /\ Assert(capacity.trash >= 0 /\ capacity.recycle >=0, 
                              "Failure of assertion at line 27, column 1.")
                    /\ Assert(Len(bins.trash) = count.trash, 
                              "Failure of assertion at line 28, column 1.")
                    /\ Assert(Len(bins.recycle) = count.recycle, 
                              "Failure of assertion at line 29, column 1.")
                    /\ pc' = "Done"
                    /\ UNCHANGED << capacity, bins, count, items, curr >>
         /\ item' = item

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 
=============================================================================
\* Modification History
\* Last modified Sun Jun 11 20:29:35 BRT 2023 by vguidi
\* Created Sun Jun 11 18:22:21 BRT 2023 by vguidi
