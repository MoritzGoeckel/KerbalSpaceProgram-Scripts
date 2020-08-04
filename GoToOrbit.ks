RUNONCEPATH("ExecNode.ks").

print "Press key to start...".
terminal:input:getchar().

STAGE.

print "Going to orbit...".

print "Executing LiftApoapsis.ks".
RUN "LiftApoapsis.ks"(80 * 1000, 90).

print "Executing CircularizePeriapsis.ks".
RUN "CircularizePeriapsis.ks".

executeNode(NEXTNODE, True).

print "Executing NormalizeOrbit.ks".
RUN "NormalizeOrbit.ks"(100 * 1000, 90).

print "Done for now".
