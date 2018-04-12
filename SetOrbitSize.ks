@LAZYGLOBAL off.
parameter orbitSize.

RUNONCEPATH("ExecNode.ks").

print "Setting orbit size to " + orbitSize.

local tolerance to 5/100.
local stepSize to 0.3.

LOCAL myNode to NODE( TIME:SECONDS, 0, 0, 0 ).

local done to False.

UNTIL done{
	if SHIP:ORBIT:APOAPSIS + SHIP:ORBIT:APOAPSIS * tolerance < orbitSize{
		print "Rising APOAPSIS".
		set myNode to NODE( TIME:SECONDS+ETA:PERIAPSIS, 0, 0, 0 ).
		ADD myNode.
		
		LOCAL delta to 0.
		UNTIL myNode:ORBIT:APOAPSIS >= orbitSize{
			set delta to delta + stepSize.
			SET myNode:PROGRADE to delta.
		}
		SET myNode:PROGRADE to delta - stepSize.
		
		executeNode(myNode).
	}
	else if SHIP:ORBIT:PERIAPSIS + SHIP:ORBIT:PERIAPSIS * tolerance < orbitSize{
		print "Rising PERIAPSIS".
		set myNode to NODE( TIME:SECONDS+ETA:APOAPSIS, 0, 0, 0 ).
		ADD myNode.
		
		LOCAL delta to 0.
		UNTIL myNode:ORBIT:PERIAPSIS >= orbitSize{
			set delta to delta + stepSize.
			SET myNode:PROGRADE to delta.
		}
		SET myNode:PROGRADE to delta - stepSize.
		
		executeNode(myNode).
	}
	else if SHIP:ORBIT:PERIAPSIS - SHIP:ORBIT:PERIAPSIS * tolerance > orbitSize{
		print "Lowering PERIAPSIS".
		set myNode to NODE( TIME:SECONDS+ETA:APOAPSIS, 0, 0, 0 ).
		ADD myNode.
		
		LOCAL delta to 0.
		UNTIL myNode:ORBIT:PERIAPSIS <= orbitSize{
			set delta to delta - stepSize.
			SET myNode:PROGRADE to delta.
		}
		SET myNode:PROGRADE to delta + stepSize.
		
		executeNode(myNode).
	}
	else if SHIP:ORBIT:APOAPSIS - SHIP:ORBIT:APOAPSIS * tolerance > orbitSize{
		print "Lowering APOAPSIS".
		set myNode to NODE( TIME:SECONDS+ETA:PERIAPSIS, 0, 0, 0 ).
		ADD myNode.
		
		LOCAL delta to 0.
		UNTIL myNode:ORBIT:APOAPSIS <= orbitSize{
			set delta to delta - stepSize.
			SET myNode:PROGRADE to delta.
		}
		SET myNode:PROGRADE to delta + stepSize.
		
		executeNode(myNode).
	}
	else{
		print "Done".
		set done to True.
	}
}