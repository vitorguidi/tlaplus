---------------------- MODULE Clock ----------------------
EXTENDS Naturals
VARIABLE hr
HCIni == hr \in (0..11)
HCnxt == 
    \/  /\ hr' = hr + 1
        /\ hr < 11  
    \/  /\ hr' = 0
        /\ hr = 11
HC == HCIni /\ [][HCnxt]_hr   
--------------------------------------------------------------
(* 
    The above line is purely cosmetic and has no meaning
*)
THEOREM HC => []HCIni
==============================================================