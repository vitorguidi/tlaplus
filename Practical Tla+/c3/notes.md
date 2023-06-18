### Chapter 3

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