lock velocity to SHIP:VELOCITY:SURFACE.

LOCK STEERING TO HEADING(90, MAX(90 - ((SHIP:APOAPSIS + 1) / orbitSize) * 90, 0)).
set THROTTLE TO 0.

set samplingDelay to 0.05.
set throttleStepsize to 0.05.

SET orbitSize TO 70000.
SET speedLimitAlt TO 10000.
SET etaApoBurnTime TO 20.

set lastVelocity to V(0,0,0).
set nextSamplingTime to 0.
set velocityDerivetive to V(0,0,0).

set steeringState TO "NONE".
set thrustState TO "NONE".

//SHIP:ALTITUDE

set done to False.

STAGE.

//Update loop
WHEN TIME > nextSamplingTime THEN { 
		
	//Screen output
	CLEARSCREEN.
	print "vel      " + velocity:MAG.
	print "vel'     " + velocityDerivetive:MAG.
	print "thrust   " + thrustState.
	print "steering " + steeringState.
	print "alt      " + ALT:RADAR + " / " + SHIP:ALTITUDE.
	
	if(SHIP:ALTITUDE < 7000){
		set desiredSpeed to 200.
	
		//Calculating velocityDerivetive
		set velocityDerivetive to ((velocity - lastVelocity) / samplingDelay).	
		set lastVelocity to velocity.
		set nextSamplingTime to TIME + samplingDelay.	
		
		//Adjusting thrust
		set desiredDerived to desiredSpeed - velocity:Z.
		set thrustState to "LIMITING to " + desiredSpeed.
		
		if velocityDerivetive:Z > desiredDerived{
			set THROTTLE to MAX(THROTTLE - throttleStepsize, 0.1).
			set thrustState to "- " + thrustState.
		}
		else if velocityDerivetive:Z < desiredDerived{
			set THROTTLE to THROTTLE + throttleStepsize.
			set thrustState to "+ " + thrustState.
		}
	}
	else{
		if SHIP:APOAPSIS > orbitSize{
			CLEARSCREEN.
			PRINT "Rised APOAPSIS to " + orbitSize + "m".
			set THROTTLE TO 0.
			set done to True.
			return False.
		}
		else{
			set thrustState to "FULL".
			set THROTTLE TO 1.
		}
	}
		
	return True.
}.

WAIT UNTIL done.

SET MYTHROTTLE TO 0.
SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.

UNLOCK THROTTLE.
UNLOCK STEERING.

//circularize