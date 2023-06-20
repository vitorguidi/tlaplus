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

## Processes

* independent execution agents
* can have local variables per process
* can await for conditions

process reader = "reader"
variable current_message = "none";
begin Read:
  while TRUE do
    await queue /= <<>>;
    current_message := Head(queue);
    queue := Tail(queue);
  end while;
end process;

* process sets: multiple processes executing same piece of code
process reader \in {"r1", "r2"}
variable current_message = "none";
begin Read:
  while TRUE do
    await queue /= <<>>;
    current_message := Head(queue);
    queue := Tail(queue);
    either
      skip;
    or
      NotifyFailure:
        current_message := "none";
        add_to_queue(self);
    end either;
  end while;
end process;


## Procedures

* Macros cannot contain labels inside, procedures can

procedure add_to_queue(val="") begin
  Add:
    await Len(queue) < MaxQueueSize;
    queue := Append(queue, val);
    return;
end procedure;

call add_to_queue("msg")

