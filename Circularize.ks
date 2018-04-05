SET myNode to NODE( TIME:SECONDS+ETA:APOAPSIS, 0, 0, 0 ).

ADD myNode.

set delta to 0.
UNTIL myNode:ORBIT:PERIAPSIS + myNode:ORBIT:PERIAPSIS * 0.05 >= myNode:ORBIT:APOAPSIS {
	set delta to delta + 1.
	SET myNode:PROGRADE to delta.
  
	CLEARSCREEN.
	print myNode:ORBIT:PERIAPSIS + "  >=  " + myNode:ORBIT:APOAPSIS.
}
print "Needed DeltaV: " + delta.

set maxAccelaration to SHIP:MAXTHRUST/SHIP:MASS.
set burnDuration to myNode:DELTAV:MAG/maxAccelaration.

print "Locking steering".
LOCK STEERING to myNode:DELTAV.

print "Starting to THROTTLE for rotation".
set THROTTLE to 0.005.
wait until vang(myNode:DELTAV, SHIP:FACING:VECTOR) < 0.25.
set THROTTLE to 0.

print "Waiting for node - " + (burnDuration/2).
wait until myNode:ETA <= (burnDuration/2).

set dv0 to myNode:DELTAV.

print "Thrusting".
set THROTTLE to 1.

//Wait for deltav vector drift
print "Waiting for drift of deltav".
wait until vdot(dv0, myNode:DELTAV) < 0.5.

set THROTTLE to 0.

REMOVE myNode.

UNLOCK STEERING.
print "Done".