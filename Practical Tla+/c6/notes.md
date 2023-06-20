## Fairness

* Stuttering => freezing in the same state
* Weakly fair: if some precondition STAYS ENABLED, the postcondition will happen
* Strongly fair: if some precondition IS REPEATEDLY ENABLED, the postcondition will happen

fair process light = "light"
begin
  Cycle:
    while at_light do
      light := NextColor(light);
    end while;
end process;
fair process car = "car"
begin
  Drive:
    when light = "green";
    at_light := FALSE;
end process;

-> does not terminate.

fair+ process car = "car"
begin
  Drive:
    when light = "green";
    at_light := FALSE;
end process;

=> make car strongly fair, terminates


## Temporal operators

* [] => always. some condition is true for every state
* <> => eventually true. For EVERY behavior, in SOME STATE the condition will be true, and may be false before and after
* ~> => leads to. a ~> b means that, if a ever bceomes true, then at some point b will be true (and not necessarily stay true).
* Termination == <>(\A self \in ProcSet: pc[self] = "Done").
* []<> => always eventually true. For finite, it assures us true at termination. For infinite, there will always be a point in the future where it is true
* <>[] => will always be true frmo a certain point in time. 


## Temporal tautologies

* []~P <=> ~<>P , []P <=> ~<>~P
* F ~> G <=> [](F => <>G)

