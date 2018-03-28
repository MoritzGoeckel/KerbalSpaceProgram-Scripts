set GRAVITY to (constant():G * body:mass) / body:radius^2.
lock KEEPSPEED to 1 / MAX(0.001, MAXTHRUST / (MASS*GRAVITY)).

lock velocity to SHIP:VELOCITY:SURFACE.

set velocityDerivetive to V(0,0,0).
set samplingDelay to 0.05.
set throttleStepsize to 0.01.

//lock THROTTLE to KEEPSPEED.
lock STEERING to UP. //SHIP:RETROGRADE

lock desiredSpeedZ to getDesiredSpeedZ().
function getDesiredSpeedZ {
	if SHIP:ALTITUDE < 300{
		return -3.
	}else if SHIP:ALTITUDE < 1300{
		return -15.
	}
	//Higher then 1300
	return -50.
}

set lastVelocity to V(0,0,0).
set nextSamplingTime to 0.

set state to "Initializing".

WHEN TIME > nextSamplingTime THEN { 
	
	//Screen output
	CLEARSCREEN.
	print "vel   " + velocity:Z.
	print "vel'  " + velocityDerivetive:Z.
	print "state " + state.
	
	//Calculating velocityDerivetive
	set velocityDerivetive to ((velocity - lastVelocity) / samplingDelay).	
	set lastVelocity to velocity.
	set nextSamplingTime to TIME + samplingDelay.	
	
	//Adjusting thrust
	if velocity:Z > desiredSpeedZ + desiredSpeedZ * 0.05 
			or velocity:Z < desiredSpeedZ - desiredSpeedZ * 0.05
	{
		set requiredDerived to (desiredSpeedZ - velocity:Z) * 0.7.
		
		set state to "des " + desiredSpeedZ + "   reqDer   " + requiredDerived.
		
		if velocityDerivetive:Z > requiredDerived{
			set THROTTLE to THROTTLE - throttleStepsize.
		}
		else if velocityDerivetive:Z < requiredDerived{
			set THROTTLE to THROTTLE + throttleStepsize.
		}
		//Else nothing
	}
	
	//Drawing vel
	SET velArrow TO VECDRAW(
      V(0,0,0),
      velocity,
      RGB(1,0,0),
      "Vel",
      1.0,
      TRUE,
      0.2
    ).
	
	SET velDirArrow TO VECDRAW(
	  V(0,0,0),
	  velocityDerivetive,
	  RGB(0,1,0),
	  "VelDir",
	  1.0,
	  TRUE,
	  0.1
	).
	
	return True.
}.

WAIT UNTIL FALSE.