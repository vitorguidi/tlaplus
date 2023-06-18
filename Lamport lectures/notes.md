### TLA+ notes

## Sets ##

* Every value is a set
* [ RM -> {"working", "prepared", "commited", "aborted"} ] : set of all arrys indexed by elements of RM with values in the set given by the possible transaction states. 
* rmState \in [RM -> {"working", "prepared", "commited", "aborted"}] : rmState is an array and it can assume any of the values of the above definition
* [i \in 1..42 |-> i^2] : takes index set [1,2,...,42] and maps it to [1,2^2,...,42^2]
* rmState' = [s \in RM -> IF s=r THEN prepared ELSE rmState[s]]
* short form for above thing is rmState' = [rmState EXCEPT ![r] = prepared]

## Records ##

* Conceptually equivalent to c structs. Order of fields does not matter
* x == [prof: {"fred","bob"}, num: {11,12}] -> set of all records x such that x.prof in (fred,bob) and x.num in (11,12)
* [prof -> "fred", num -> 12] => single record value. is an element of the set defined above

## UNCHANGED ##

* For transitions that do not change variables we can use unchanged<<rmState, tmState, msgs>>