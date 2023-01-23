### Concepts


* Deadlock
* Starvation

### 1. Mutual exclusion (pets cannot be together in yard)

Alice

* Raise flag
* When Bob's flag is down, release cat
* When cat comes back, lower flag

Bob:

* Raise flag
* While Alice flag is up:
    - Lower flag
    - Wait untill Alice flag goes up
    - Raise flag
* When he sees Alice flag down, releases dog
* When dog is back, lower flag

### Producer-consumer

Alice

* Waits until can is down
* Releases pets
* If pets ate everything, raise can

Bob

* Waits for can to be up
* Refills food
* Drops can