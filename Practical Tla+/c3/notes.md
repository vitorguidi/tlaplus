
## Operators

* Operator is like a procedure in imperative programming
* Op(arg1, arg2) == Expr. Ie, Sum(x,y) == x + y
* If the expression does not depend on arguments, we can do: Op == expr (ex: Batata = {1,2,3})
* Higher order operators can take other operators as arguments. We need to specify number of arguments beforehand, ie: DummyOp(x,y, op(_,_)) == op(x,y)

## Logical operators

* \A x \in S: P(x) ( every el x in set S satisfies property P)
* Negated form: ~\A => (there exists at least one that does not satisfy)
* \E x \in S: P(x) (exists one el in set that satisfies property P)
* negated form: ~\E (for all elements, P is not valid)
* X <=> Y 
* X => Y
* X /\ P
* X \/ P


## Expressions

* things that assume value (A \/ B)
* LET IN: allows us to lcoally declare an expression. IE:
    RotateRight(seq) ==
  LET
    last == seq[Len(seq)]
    first == SubSeq(seq, 1, Len(seq) - 1)
  IN <<last>> \o first
* IF exp1 THEN exp2 ELSE exp3; (else is mandatory)
* Case: Equivalent to a switch statement.
CASE x = 1 -> TRUE
  [] x = 2 -> TRUE
  [] x = 3 -> 7
  [] OTHER -> FALSE

* CHOOSE x \in S: P(x) => chooses an arbitrary (deterministic) element of a set that satisfies some property


## Functions

* maps domain to counterdomain
* physically, map of argument to value
* [x \in S: P(x)]
* tuple = function with 1..n as domain
* struct = function with string set as domain


## Functions and operators

* Functions can be defined as operators
* if the operator does not take arguments:
Op == [x \in S |-> P(x)]
Op[x \in S] == P(x)
* if the operator does take arguments:
MapToSomeNumber(set, num) == [x \in set |-> num]
* functions can be created within operators
SumUpTo(n) ==
  LET F[m \in 0..n] ==
    IF m = 0 THEN 0
    ELSE m + F[m-1]
  IN F[n]
* Domain f => returns the domain of function f


## Sets of functions

* [set1 -> set2] is the set of all functions that map elements of set1 to elements of set2.
* DO NOT MIX BETWEEN |-> and ->
