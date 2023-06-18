## Labels

* Atomic units of execution within spec
* Rules:

•You must have a label at the beginning of each process and before
every while.

•You may not place a label inside a macro or a with statement.
•You must place a label after every goto.

•If you use an either or an if and any possible branch has a label
inside it, you must place a label after the end of the control structure.

•You may not assign to the same variable twice in a label.

More specifically:

LabelGood:
    x.key1=1;
    x.key2=2;        ->> dont

LabelGood:
    x.key1=1 || x.key2=2;