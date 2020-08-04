RUNONCEPATH("ExecNode.ks").

LOCAL myNode to NODE(TIME:SECONDS+ETA:APOAPSIS, 0, 0, 0 ).
ADD myNode.

print "Searching for circularizing manoeuvre...".

// TODO: Diff should always be abs, positive
LOCAL diff TO myNode:ORBIT:APOAPSIS - myNode:ORBIT:PERIAPSIS.
LOCAL acceleration to 0.
LOCAL stepsize TO 10.
UNTIL ABS(stepsize) < 0.01 {
    SET acceleration to acceleration + stepsize.
    SET myNode:PROGRADE to acceleration.

    if (myNode:ORBIT:APOAPSIS - myNode:ORBIT:PERIAPSIS > diff){
        SET stepsize TO stepsize * -1.0. // Turn direction
        SET stepsize TO stepsize / 2.0. // Half the size
    }
    SET diff TO myNode:ORBIT:APOAPSIS - myNode:ORBIT:PERIAPSIS.
}

print "Diff after setting PROGRADE: " + ROUND(diff, 2).

SET diff TO myNode:ORBIT:APOAPSIS - myNode:ORBIT:PERIAPSIS.
SET acceleration TO 0.
SET stepsize TO 10.
UNTIL ABS(stepsize) < 0.01 {
    SET acceleration to acceleration + stepsize.
    SET myNode:RADIALOUT to acceleration.

    if (myNode:ORBIT:APOAPSIS - myNode:ORBIT:PERIAPSIS > diff){
        SET stepsize TO stepsize * -1.0. // Turn direction
        SET stepsize TO stepsize / 2.0. // Half the size
    }
    SET diff TO myNode:ORBIT:APOAPSIS - myNode:ORBIT:PERIAPSIS.
}

print "Diff after setting RADIALOUT: " + ROUND(diff, 2).

print "Found circularizing manoeuvre".
print "Needed DeltaV: " + acceleration.
print myNode:ORBIT:PERIAPSIS + "  ->  " + myNode:ORBIT:APOAPSIS.
