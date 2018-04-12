RUNONCEPATH("ExecNode.ks").

print "Starting way to Minmus... ".

print "Executing LiftApoapsis.ks".
RUN "LiftApoapsis.ks"(80 * 1000, 90).

print "Executing CircularizePeriapsis.ks".
RUN "CircularizePeriapsis.ks".

print "Executing AlignOrbit.ks".
RUN "AlignOrbit.ks"(Minmus).

print "Executing FindEncounter.ks".
RUN "FindEncounter.ks"(Minmus).

executeNode(NEXTNODE).