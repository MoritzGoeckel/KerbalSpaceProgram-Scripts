parameter paramOrbitSize.
parameter paramAngle.

LOCAL lock velocity to SHIP:VELOCITY:SURFACE.

set THROTTLE TO 0.

LOCAL samplingDelay to 0.05.
LOCAL throttleStepsize to 0.05.

LOCAL orbitSize TO 70000.
LOCAL speedLimitAlt TO 10000.
LOCAL etaApoBurnTime TO 20.

LOCAL lastVelocity to V(0,0,0).
LOCAL nextSamplingTime to 0.
LOCAL velocityDerivetive to V(0,0,0).

LOCAL steeringState TO "NONE".
LOCAL thrustState TO "NONE".

LOCAL steeringAngle to 90.

if defined paramOrbitSize{
	set orbitSize to paramOrbitSize.
	print "Using parameter for obritSize".
}
else{
	print "No OrbitSize parameter found. Using " + orbitSize.
}

if defined paramAngle{
	set steeringAngle to paramAngle.
	print "Using parameter for SteeringAngle".
}
else{
	print "No SteeringAngle parameter found. Using " + steeringAngle.
}

LOCK STEERING TO HEADING(steeringAngle, MAX(90 - ((SHIP:APOAPSIS + 1) / orbitSize) * 90, 0)).

LOCAL done to False.

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
		LOCAL desiredSpeed to 200.
	
		//Calculating velocityDerivetive
		set velocityDerivetive to ((velocity - lastVelocity) / samplingDelay).	
		set lastVelocity to velocity.
		set nextSamplingTime to TIME + samplingDelay.	
		
		//Adjusting thrust
		LOCAL desiredDerived to desiredSpeed - velocity:Z.
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

UNLOCK THROTTLE.
UNLOCK STEERING.

SET THROTTLE TO 0.
SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.

CLEARSCREEN.
PRINT "Rised APOAPSIS to " + orbitSize + "m".
