------------------------------ MODULE diehard ------------------------------
EXTENDS Integers
VARIABLES small, big

TypeOK == /\ small \in 0..3
          /\ big \in 0..5
          
Init == /\ big = 0
        /\ small = 0
        
FillSmall == /\ small' = 3
            /\ big' = big
            
FillBig == /\ small' = small
          /\ big' = 5

EmptySmall == /\ small' = 0
             /\ big' = big
                
EmptyBig == /\ big' = 0
           /\ small' = small
           
SmallToBig == IF small + big >= 5
                THEN /\ small' = small - (5-big)
                     /\ big' = 5
              ELSE /\ small' =  0
                   /\ big' = small + big

BigToSmall == IF small + big >= 3
                THEN /\ small' = 3
                     /\ big' = big - (3-small)
              ELSE /\ big' = 0
                   /\ small' = small + big                     
            
Next ==     \/ FillBig
            \/ FillSmall
            \/ EmptyBig
            \/ EmptySmall
            \/ BigToSmall
            \/ SmallToBig
            
TypeOk == /\ small >= 0
         /\ small <= 5
         /\ big >= 0
         /\ big <= 5     

=============================================================================
\* Modification History
\* Last modified Mon Jan 09 17:41:51 BRT 2023 by vitor
\* Created Mon Jan 09 16:39:11 BRT 2023 by vitor
