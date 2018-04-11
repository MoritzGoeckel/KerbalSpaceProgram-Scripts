WHEN MAXTHRUST = 0 THEN {
    PRINT "Staging".
    STAGE.
    PRESERVE.
}.

//Round
PRINT ROUND(SHIP:APOAPSIS,0) AT (0,16).


WHEN STAGE:LIQUIDFUEL < 0.1 THEN {
    STAGE.
    PRESERVE.
}

RUNPATH("filename", arg1, arg2).


//https://en.wikipedia.org/wiki/PID_controller
//https://ksp-kos.github.io/KOS/structures/misc/pidloop.html#structure:PIDLOOP