@LAZYGLOBAL off.
parameter orbitSize.

RUNONCEPATH("ExecNode.ks").

print "Setting orbit size to " + orbitSize.

LOCAL tolerance TO orbitSize * 0.03.
LOCK altOtherSide TO (POSITIONAT(SHIP, TIME:SECONDS + (SHIP:ORBIT:PERIOD / 2)) - SHIP:BODY:POSITION):MAG - SHIP:BODY:RADIUS.

GLOBAL THROTTLE TO 0.
print "OtherSideAlt: " + altOtherSide.

UNTIL False {
    GLOBAL THROTTLE to 0.
    WAIT 5.
    print "Warping...".
    SET KUNIVERSE:TIMEWARP:WARP to 3.

    WAIT UNTIL altOtherSide + tolerance < orbitSize OR altOtherSide - tolerance > orbitSize OR (SHIP:ORBIT:PERIAPSIS + tolerance > orbitSize AND SHIP:ORBIT:PERIAPSIS - tolerance < orbitSize AND SHIP:ORBIT:APOAPSIS + tolerance > orbitSize AND SHIP:ORBIT:APOAPSIS - tolerance < orbitSize).

    LOCAL need_correction TO False.
    LOCAL raising TO False.
    if (altOtherSide + tolerance < orbitSize){
        LOCK STEERING TO SHIP:VELOCITY:ORBIT. // Prograde
        SET need_correction TO True.
        SET raising TO True.
    } else if (altOtherSide - tolerance > orbitSize){
        LOCK STEERING TO -SHIP:VELOCITY:ORBIT. // Retrograde
        SET need_correction TO True.
        SET raising TO False.
    }

    if (need_correction) {
        kuniverse:timewarp:CANCELWARP().
        print "Correcting: " + altOtherSide + " -> " + orbitSize.

        print "Waiting for vessel to align...".
        RCS ON.
        WAIT UNTIL VANG(STEERING, SHIP:FACING:VECTOR) < 0.25.

        GLOBAL THROTTLE to 1.
        if (raising) WAIT UNTIL altOtherSide > orbitSize.
        else         WAIT UNTIL altOtherSide < orbitSize.
        GLOBAL THROTTLE to 0.
        RCS OFF.

        print "Done correcting: " + altOtherSide + " -> " + orbitSize.
    }

    if (SHIP:ORBIT:PERIAPSIS + tolerance > orbitSize AND SHIP:ORBIT:PERIAPSIS - tolerance < orbitSize AND SHIP:ORBIT:APOAPSIS + tolerance > orbitSize AND SHIP:ORBIT:APOAPSIS - tolerance < orbitSize){
        print "Done normalizing".
        break.
    }
}

kuniverse:timewarp:CANCELWARP().
UNLOCK THROTTLE.
UNLOCK STEERING.

print "End".
