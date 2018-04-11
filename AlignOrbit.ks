parameter mytarget.

if defined mytarget {
	//Dont know how to check for false :D
}
else {
	print "FATAL: No target param found!".
}

LOCAL myNode to NODE( TIME:SECONDS + 100, 0, 0, 0 ).

ADD myNode.

LOCAL lock vel_target to mytarget:obt:velocity:orbit:normalized.
LOCAL lock pos_target to (mytarget:obt:body:POSITION - mytarget:obt:POSITION):normalized.

LOCAL lock normal_target to VECTORCROSSPRODUCT(pos_target, vel_target):NORMALIZED.

LOCAL lock vel_me to myNode:obt:velocity:orbit:normalized.
LOCAL lock pos_me to (myNode:obt:body:POSITION - myNode:obt:POSITION):normalized.

LOCAL lock normal_me to VECTORCROSSPRODUCT(pos_me, vel_me):NORMALIZED.

print (normal_target - normal_me):MAG.

LOCAL smallestDifference to 1000000.
LOCAL smallestDifferenceETA to 0.
LOCAL smallestDeltaV to 0.

findAscDescNode(5).
findAscDescNode(-5).

LOCAL function findAscDescNode {
    declare local parameter normalDeltaV.
	
	print "Finding ac/dc node...".
	print "Direction: " + normalDeltaV.
	
	LOCAL timeDelta to 1.
	SET myNode:NORMAL to normalDeltaV.
	UNTIL timeDelta >= Orbit:PERIOD  {
		LOCAL difference to (normal_target - normal_me):MAG.
		SET myNode:ETA to timeDelta.
		
		if difference < smallestDifference{
			set smallestDifference to difference.
			set smallestDifferenceETA to timeDelta.
			set smallestDeltaV to normalDeltaV.
			
			//CLEARSCREEN.
			//print "Diff: " + smallestDifference.
			//print "ETA: " + smallestDifferenceETA.
			//print "Normal: " + smallestDeltaV.
		}
		
		set timeDelta to timeDelta + 10.
	}
}

SET myNode:ETA to smallestDifferenceETA.
SET myNode:NORMAL to smallestDeltaV.

LOCAL lastDifference to 1000000.
LOCAL dir to (myNode:NORMAL / abs(myNode:NORMAL)).

print "Finding optimal normal burn...".
print "Direction: " + dir.

UNTIL False {
	LOCAL difference to (normal_target - normal_me):MAG.
		
	if difference > lastDifference{
		SET myNode:NORMAL to myNode:NORMAL - dir.
		break.
	}
	
	SET myNode:NORMAL to myNode:NORMAL + dir.
	set lastDifference to difference. 
}

RUN "ExecNode.ks"(myNode).

print "Done".