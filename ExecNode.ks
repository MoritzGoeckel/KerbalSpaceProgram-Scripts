declare global function executeNode {
    parameter execManeuvreNode.
    DECLARE PARAMETER heavyShip is False.

    local stopWarpingBefore to 10.
    if(heavyShip){
        print "Is a heavy ship!".
        set stopWarpingBefore to 45.
    }

    print "Executing node".

    print "Locking steering".
    LOCK STEERING to execManeuvreNode:DELTAV.

    if(execManeuvreNode:DELTAV:MAG > 20){
        RCS ON.
    }

    wait until vang(execManeuvreNode:DELTAV, SHIP:FACING:VECTOR) < 0.25.
    RCS OFF.

    LOCK maxAccelaration to SHIP:MAXTHRUST/SHIP:MASS.
    LOCK burnScale to min((execManeuvreNode:DELTAV:MAG/maxAccelaration) / 10, 1).
    LOCK burnDuration to execManeuvreNode:DELTAV:MAG/maxAccelaration/burnScale.

    print "BurnScale:      " + burnScale.
    print "BurnDuration:   " + burnDuration.
    print "Waiting for node -" + (burnDuration/2) + "s".

    KUNIVERSE:TIMEWARP:WARPTO((time:seconds + (execManeuvreNode:ETA - (burnDuration/2))) - stopWarpingBefore).
    wait until execManeuvreNode:ETA <= (burnDuration/2) + stopWarpingBefore.

    if(execManeuvreNode:DELTAV:MAG > 20 or heavyShip){
        RCS ON.
    }
    if(heavyShip){
        print "Using engine to stabalize ship".
        set THROTTLE to 0.07.
    }

    wait until execManeuvreNode:ETA <= (burnDuration/2).

    print "Waiting for vessel to align...".
    wait until vang(execManeuvreNode:DELTAV, SHIP:FACING:VECTOR) < 0.25.

    print "Thrusting".
    LOCAL dv0 to execManeuvreNode:DELTAV.
    GLOBAL THROTTLE to burnScale.

    //Wait for deltav vector drift
    print "Waiting for drift of deltav".
    wait until vdot(dv0, execManeuvreNode:DELTAV) < 0.5.

    UNLOCK burnScale.
    UNLOCK maxAccelaration.
    UNLOCK burnDuration.

    GLOBAL THROTTLE to 0.
    RCS OFF.

    UNLOCK THROTTLE.
    UNLOCK STEERING.

    REMOVE execManeuvreNode.

    print "Done executing node".
}
