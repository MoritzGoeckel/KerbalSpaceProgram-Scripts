parameter orbitSize.

print "Setting orbit size to " + orbitSize.

local tolerance to 10/100.

LOCAL myNode to NODE( TIME:SECONDS, 0, 0, 0 ).

local done to False.

UNTIL done{
	if SHIP:ORBIT:APOAPSIS + SHIP:ORBIT:APOAPSIS * tolerance < orbitSize{
		print "Rising APOAPSIS".
		set myNode to NODE( TIME:SECONDS+ETA:PERIAPSIS, 0, 0, 0 ).
		ADD myNode.
		
		LOCAL delta to 0.
		UNTIL myNode:ORBIT:APOAPSIS >= orbitSize{
			set delta to delta + 1.
			SET myNode:PROGRADE to delta.
		}
		
		RUN "ExecNode.ks"(myNode).
	}
	else if SHIP:ORBIT:PERIAPSIS + SHIP:ORBIT:PERIAPSIS * tolerance < orbitSize{
		print "Rising PERIAPSIS".
		set myNode to NODE( TIME:SECONDS+ETA:APOAPSIS, 0, 0, 0 ).
		ADD myNode.
		
		LOCAL delta to 0.
		UNTIL myNode:ORBIT:PERIAPSIS >= orbitSize{
			set delta to delta + 1.
			SET myNode:PROGRADE to delta.
		}
		
		RUN "ExecNode.ks"(myNode).
	}
	else if SHIP:ORBIT:PERIAPSIS - SHIP:ORBIT:PERIAPSIS * tolerance > orbitSize{
		print "Lowering PERIAPSIS".
		set myNode to NODE( TIME:SECONDS+ETA:APOAPSIS, 0, 0, 0 ).
		ADD myNode.
		
		LOCAL delta to 0.
		UNTIL myNode:ORBIT:PERIAPSIS <= orbitSize{
			set delta to delta - 1.
			SET myNode:PROGRADE to delta.
		}
		
		RUN "ExecNode.ks"(myNode).
	}
	else if SHIP:ORBIT:APOAPSIS - SHIP:ORBIT:APOAPSIS * tolerance > orbitSize{
		print "Lowering APOAPSIS".
		set myNode to NODE( TIME:SECONDS+ETA:PERIAPSIS, 0, 0, 0 ).
		ADD myNode.
		
		LOCAL delta to 0.
		UNTIL myNode:ORBIT:APOAPSIS <= orbitSize{
			set delta to delta - 1.
			SET myNode:PROGRADE to delta.
		}
		
		RUN "ExecNode.ks"(myNode).
	}
	else{
		print "Done".
		set done to True.
	}
}