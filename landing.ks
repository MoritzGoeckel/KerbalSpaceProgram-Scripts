lock velocity to SHIP:VELOCITY:SURFACE.

//Settings
set samplingDelay to 0.05.
set throttleStepsize to 0.01.
set velTolerance to 0.05.
SAS OFF.

//Steering routine

lock STEERING to getLandingSteering().
function getLandingSteering {
	if velocity:Z < -10 {
		set steeringState to "Retrograde".
		return (-1) * SHIP:VELOCITY:SURFACE.
	}
	set steeringState to "Up".
	return UP:VECTOR.
}

//Speed routine

lock desiredSpeedZ to getDesiredSpeedZ().
function getDesiredSpeedZ {
	
	//Define landing speed sequence here
	if ALT:RADAR < 10{
		return -0.5.
	}
	else if ALT:RADAR < 20{
		return -1.
	}
	else if ALT:RADAR < 50{
		LIGHTS ON. //Nasty side effects
		return -2.
	}
	else if ALT:RADAR < 100{
		return -10.
	}
	else if ALT:RADAR < 500{
		return -20.
	}
	else if ALT:RADAR < 1500{
		return -50.
	}
	
	LIGHTS OFF.
	return -100.
}

//Drawing arrows

SET steeringArrow TO VECDRAW(
	V(0,0,0),
	STEERING,
	RGB(0,0,1),
	"Steering",
	1.0,
	TRUE,
	0.1
).

SET velArrow TO VECDRAW(
	V(0,0,0),
	velocity,
	RGB(1,0,0),
	"Vel",
	1.0,
	TRUE,
	0.2
).

//Internal variables

set lastVelocity to V(0,0,0).
set nextSamplingTime to 0.
set velocityDerivetive to V(0,0,0).

set thrustState to "Initializing".
set steeringState to "Initializing".

//Update loop

WHEN TIME > nextSamplingTime THEN { 
		
	//Screen output
	CLEARSCREEN.
	print "vel      " + velocity:Z.
	print "vel'     " + velocityDerivetive:Z.
	print "thrust   " + thrustState.
	print "steering " + steeringState.
	print "alt      " + ALT:RADAR + " / " + SHIP:ALTITUDE.
	
	//Calculating velocityDerivetive
	set velocityDerivetive to ((velocity - lastVelocity) / samplingDelay).	
	set lastVelocity to velocity.
	set nextSamplingTime to TIME + samplingDelay.	
	
	//Adjusting thrust
	if velocity:Z > desiredSpeedZ + desiredSpeedZ * velTolerance 
			or velocity:Z < desiredSpeedZ - desiredSpeedZ * velTolerance
	{
		set requiredDerived to (desiredSpeedZ - velocity:Z).
		set thrustState to "desired " + desiredSpeedZ + " | desired' " + requiredDerived.
		
		if velocityDerivetive:Z > requiredDerived{
			set THROTTLE to THROTTLE - throttleStepsize.
		}
		else if velocityDerivetive:Z < requiredDerived{
			set THROTTLE to THROTTLE + throttleStepsize.
		}
	}
	
	return True.
}.

WAIT UNTIL FALSE.