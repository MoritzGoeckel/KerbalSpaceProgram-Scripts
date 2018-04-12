RUNONCEPATH("ExecNode.ks").

LOCAL myNode to NODE( TIME:SECONDS+ETA:APOAPSIS, 0, 0, 0 ).

ADD myNode.

print "Searching for circularizing manoeuvre...".

LOCAL delta to 0.
UNTIL myNode:ORBIT:PERIAPSIS + myNode:ORBIT:PERIAPSIS * 0.05 >= myNode:ORBIT:APOAPSIS {
	set delta to delta + 1.
	SET myNode:PROGRADE to delta.
}

print "Found circularizing manoeuvre".
print "Needed DeltaV: " + delta.
print myNode:ORBIT:PERIAPSIS + "  ->  " + myNode:ORBIT:APOAPSIS.

executeNode(myNode).

print "Done ".