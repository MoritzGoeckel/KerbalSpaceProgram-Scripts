DECLARE parameter mytarget.

RUNONCEPATH("ExecNode.ks").

if(SHIP:ORBIT:HASNEXTPATCH and SHIP:ORBIT:NEXTPATCH:BODY = mytarget){
	print "Warping to next encounter".
	local otherOrbit to SHIP:ORBIT:NEXTPATCH.
	local arrivalTime to time:seconds + SHIP:ORBIT:NEXTPATCHETA + 5.
	KUNIVERSE:TIMEWARP:WARPTO(arrivalTime).
	wait until time:seconds >= arrivalTime.
}

if(SHIP:ORBIT:BODY = mytarget and SHIP:ORBIT:HASNEXTPATCH){
	LOCAL myNode to NODE( TIME:SECONDS+ETA:PERIAPSIS, 0, 0, 0 ).
	ADD myNode.
	
	print "Searching for circularizing manoeuvre...".

	LOCAL delta to 0.
	UNTIL myNode:ORBIT:HASNEXTPATCH = False {
		set delta to delta - 1.
		SET myNode:PROGRADE to delta.
	}
	
	print "Found circularizing manoeuvre".
	print "Needed DeltaV: " + delta.
	
	executeNode(myNode).
}

print "Done catching".