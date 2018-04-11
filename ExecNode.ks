parameter myNode.

print "Executing node " + myNode.

LOCAL maxAccelaration to SHIP:MAXTHRUST/SHIP:MASS.
LOCAL burnDuration to myNode:DELTAV:MAG/maxAccelaration.

print "Locking steering".
local LOCK STEERING to myNode:DELTAV.

//print "Starting to THROTTLE for rotation".
//set THROTTLE to 0.005.

wait until vang(myNode:DELTAV, SHIP:FACING:VECTOR) < 0.25.
set THROTTLE to 0.

print "Waiting for node minus " + (burnDuration/2) + "s".

KUNIVERSE:TIMEWARP:WARPTO((time:seconds + (myNode:ETA - (burnDuration/2))) - 5).

wait until myNode:ETA <= (burnDuration/2).

LOCAL dv0 to myNode:DELTAV.

print "Thrusting".
set THROTTLE to 1.

//Wait for deltav vector drift
print "Waiting for drift of deltav".
wait until vdot(dv0, myNode:DELTAV) < 0.5.

set THROTTLE to 0.

print "Done executing node " + myNode.

UNLOCK THROTTLE.
UNLOCK STEERING.

REMOVE myNode.