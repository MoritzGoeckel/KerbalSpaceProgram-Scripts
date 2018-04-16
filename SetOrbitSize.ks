@LAZYGLOBAL off.
parameter orbitSize.

RUNONCEPATH("ExecNode.ks").

print "Setting orbit size to " + orbitSize.

local tolerance to 5/100*orbitSize.
local stepSize to 0.1.

print "Tolerance is " + tolerance.

LOCAL myNode to NODE( TIME:SECONDS, 0, 0, 0 ).

local done to False.

UNTIL done{
	if SHIP:ORBIT:APOAPSIS + tolerance < orbitSize{
		print "Rising APOAPSIS".
		set myNode to NODE( TIME:SECONDS+ETA:PERIAPSIS, 0, 0, 0 ).
		ADD myNode.
		
		LOCAL delta to 0.
		UNTIL myNode:ORBIT:APOAPSIS >= orbitSize{
			set delta to delta + stepSize.
			SET myNode:PROGRADE to delta.
		}
		
		executeNode(myNode).
	}
	else if SHIP:ORBIT:PERIAPSIS - tolerance > orbitSize{
		print "Lowering PERIAPSIS".
		set myNode to NODE( TIME:SECONDS+ETA:APOAPSIS, 0, 0, 0 ).
		ADD myNode.
		
		LOCAL delta to 0.
		UNTIL myNode:ORBIT:PERIAPSIS <= orbitSize{
			set delta to delta - stepSize.
			SET myNode:PROGRADE to delta.
		}
		
		executeNode(myNode).
	}
	//Problem
	else if SHIP:ORBIT:PERIAPSIS + tolerance < orbitSize{
		print "Rising PERIAPSIS".
		set myNode to NODE( TIME:SECONDS+ETA:APOAPSIS, 0, 0, 0 ).
		ADD myNode.
		
		LOCAL delta to 0.
		UNTIL myNode:ORBIT:PERIAPSIS >= orbitSize or myNode:ORBIT:PERIAPSIS + tolerance/2 > myNode:ORBIT:APOAPSIS{
			set delta to delta + stepSize.
			SET myNode:PROGRADE to delta.
		}
		
		executeNode(myNode).
		set done to True.
	}
	//Problem
	else if SHIP:ORBIT:APOAPSIS - tolerance > orbitSize{
		print "Lowering APOAPSIS".
		set myNode to NODE( TIME:SECONDS+ETA:PERIAPSIS, 0, 0, 0 ).
		ADD myNode.
		
		LOCAL delta to 0.
		UNTIL myNode:ORBIT:APOAPSIS <= orbitSize or myNode:ORBIT:APOAPSIS - tolerance/2 < myNode:ORBIT:PERIAPSIS{
			set delta to delta - stepSize.
			SET myNode:PROGRADE to delta.
		}
		
		executeNode(myNode).
		set done to True.
	}
	else{
		set done to True.
	}
}

print "Done".