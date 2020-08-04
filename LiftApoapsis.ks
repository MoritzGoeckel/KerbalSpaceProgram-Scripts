PARAMETER orbitSize.
PARAMETER steeringAngle.
DECLARE PARAMETER limitSpeed is True.

LOCAL samplingDelay to 0.05.
LOCAL throttleStepsize to 0.05.
LOCAL minThrottle TO 0.2.

LOCAL lastVelocity to 0.
LOCAL nextSamplingTime to 0.
LOCAL velocityDerivetive to 0.
LOCAL thrustState TO "NONE".
LOCAL done to False.

SET THROTTLE TO 0.
LOCK STEERING TO HEADING(steeringAngle, MAX(90 - ((SHIP:APOAPSIS + 1) / orbitSize) * 90, 0)).
LOCAL lock velocity to SHIP:AIRSPEED.

//Update loop
WHEN TIME > nextSamplingTime THEN { 

    //Screen output
    CLEARSCREEN.
    print "Vel         " + ROUND(velocity, 2).
    print "Vel'        " + ROUND(velocityDerivetive, 2).
    print "Thrust      " + thrustState.
    print "tSteering   " + steeringAngle.
    print "Alt S/R     " + ROUND(ALT:RADAR, 2) + " / " + ROUND(SHIP:ALTITUDE, 2).
    print "Apo         " + ROUND(SHIP:APOAPSIS, 2).
    print "tApo        " + orbitSize.

    // Speed limit for less friction
    LOCAL desiredSpeed to 99999999999.
    if(limitSpeed){
        if(SHIP:ALTITUDE < 6 * 1000){
            SET desiredSpeed TO 200.
        } else if(SHIP:ALTITUDE < 9 * 1000){
            SET desiredSpeed TO 300.
        } else if(SHIP:ALTITUDE < 11 * 1000){
            SET desiredSpeed TO 350.
        } else if(SHIP:ALTITUDE < 13 * 1000){
            SET desiredSpeed TO 400.
        }
    }

    //Calculating velocityDerivetive
    set velocityDerivetive to ((velocity - lastVelocity) / samplingDelay).
    set lastVelocity to velocity.
    set nextSamplingTime to TIME + samplingDelay.

    //Adjusting thrust
    LOCAL desiredDerived to desiredSpeed - velocity.
    set thrustState to "LIMITING to " + ROUND(desiredSpeed, 2).

    if velocityDerivetive > desiredDerived{
        set THROTTLE to MAX(THROTTLE - throttleStepsize, minThrottle). //To prevent flipping
        set thrustState to "- " + thrustState.
    }
    else if velocityDerivetive < desiredDerived{
        set THROTTLE to THROTTLE + throttleStepsize.
        set thrustState to "+ " + thrustState.
    }

    if SHIP:APOAPSIS > orbitSize{
        set THROTTLE TO 0.
        set done to True.
        return False.
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
