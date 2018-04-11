LOCAL myNode to NODE( TIME:SECONDS+ETA:PERIAPSIS, 0, 0, 0 ).

ADD myNode.

print "Searching for circularizing manoeuvre...".

LOCAL delta to 0.
UNTIL myNode:ORBIT:APOAPSIS > 0 and myNode:ORBIT:APOAPSIS - myNode:ORBIT:APOAPSIS * 0.05 <= myNode:ORBIT:PERIAPSIS {
	set delta to delta - 1.
	SET myNode:PROGRADE to delta.
}

print "Found circularizing manoeuvre".
print "Needed DeltaV: " + delta.
print myNode:ORBIT:PERIAPSIS + "  ->  " + myNode:ORBIT:APOAPSIS.

//RUN "ExecNode.ks"(myNode).

print "Done ".