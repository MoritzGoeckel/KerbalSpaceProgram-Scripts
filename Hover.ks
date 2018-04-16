
local hoveringHight to 100.

lock altr to min(ALT:RADAR / hoveringHight, 1).
lock targetVec to (TARGET:POSITION - SHIP:POSITION):NORMALIZED * (altr).
lock upVec to SHIP:UP:VECTOR:NORMALIZED * (1 - altr).

lock STEERING to (targetVec + upVec):DIRECTION.

LOCAL nextSamplingTime to 0.

WHEN TIME > nextSamplingTime THEN { 
	clearscreen.
	print altr.
	print ALT:RADAR.
	
	print "Target: 	" +  (altr).
	print "UP: 		" +  (1 - altr).
	
	set nextSamplingTime to TIME + 1.	
	return True.
}

wait until false.