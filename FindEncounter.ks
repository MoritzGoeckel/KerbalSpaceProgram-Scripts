parameter mytarget.

LOCAL myNode to NODE( TIME:SECONDS + 1, 0, 0, 0 ).

ADD myNode.

LOCAL targetOrbitSize to ((mytarget:ORBIT:APOAPSIS + mytarget:ORBIT:PERIAPSIS) / 2).

LOCAL timeDelta to 1.
UNTIL timeDelta >= Orbit:PERIOD  {
	SET myNode:ETA to timeDelta.
	
	//Set it to below
	UNTIL myNode:ORBIT:APOAPSIS < targetOrbitSize{
		SET myNode:PROGRADE to myNode:PROGRADE - 1.
	}
	
	//Push until reach size again
	UNTIL myNode:ORBIT:APOAPSIS > targetOrbitSize{
		SET myNode:PROGRADE to myNode:PROGRADE + 1.
	}
	
	if(myNode:Orbit:HASNEXTPATCH and myNode:Orbit:NEXTPATCH:BODY = mytarget){
		print "Found encounter".
		break.
	}
		
	set timeDelta to timeDelta + 10.
}