parameter paramNode.

LOCAL myNode to NEXTNODE.

if defined paramNode{
	print "Using parameter".
	set myNode to paramNode.
}
else{
	print "No param... using NEXTNODE".
}

print "Executing node " + myNode.

LOCAL maxAccelaration to SHIP:MAXTHRUST/SHIP:MASS.
LOCAL burnDuration to myNode:DELTAV:MAG/maxAccelaration.

print "Locking steering".
LOCK STEERING to myNode:DELTAV.

print "Starting to THROTTLE for rotation".
set THROTTLE to 0.01.
wait until vang(myNode:DELTAV, SHIP:FACING:VECTOR) < 0.25.
set THROTTLE to 0.

print "Waiting for node minus " + (burnDuration/2) + "s".
wait until myNode:ETA <= (burnDuration/2).

LOCAL dv0 to myNode:DELTAV.

print "Thrusting".
set THROTTLE to 1.

//Wait for deltav vector drift
print "Waiting for drift of deltav".
wait until vdot(dv0, myNode:DELTAV) < 0.5.

set THROTTLE to 0.

print "Done executing node " + myNode.

REMOVE myNode.

UNLOCK THROTTLE.
UNLOCK STEERING.