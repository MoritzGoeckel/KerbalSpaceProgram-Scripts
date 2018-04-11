print "Starting way to minmus... ".

print "Executing RiseApoapsis.ks".
RUN "RiseApoapsis.ks"(80 * 1000, 90).

print "Executing Circularize.ks".
RUN "Circularize.ks".

print "Executing AlignOrbit.ks".
RUN "AlignOrbit.ks"(Minmus).