//This is KerboScript
//See documentation here: https://ksp-kos.github.io/KOS/language

//This is an basic script to get from launch pad into orbit on planet Kerbin

SET orbitSize TO 70000.
SET speedLimitAlt TO 7000.
SET etaApoBurnTime TO 20.
SET maxVelSpeedLimit TO 200.

STAGE.

CLEARSCREEN.

SET MYTHROTTLE TO 1.0.
LOCK THROTTLE TO MYTHROTTLE.

LOCK MYSTEER TO HEADING(90, MAX(90 - ((SHIP:APOAPSIS + 1) / orbitSize) * 90, 0)).
LOCK STEERING TO MYSTEER.

SET nextThrottleCheck TO TIME.

UNTIL SHIP:PERIAPSIS > orbitSize{
	
	IF SHIP:ALTITUDE < speedLimitAlt AND TIME > nextThrottleCheck{
		IF SHIP:VELOCITY:SURFACE:MAG > maxVelSpeedLimit{
			SET MYTHROTTLE TO MYTHROTTLE - 0.001.
		}.
		ELSE IF MYTHROTTLE < 1.0 AND SHIP:VELOCITY:SURFACE:MAG < maxVelSpeedLimit{
			SET MYTHROTTLE TO MYTHROTTLE + 0.001.
		}.
		SET nextThrottleCheck TO nextThrottleCheck + 0.01.
	}.
	
	IF SHIP:ALTITUDE > speedLimitAlt AND SHIP:APOAPSIS < orbitSize{
		SET MYTHROTTLE TO 1.
	}
	
	IF SHIP:APOAPSIS > orbitSize{
		IF ETA:APOAPSIS > etaApoBurnTime AND ETA:APOAPSIS < 10 * 60{
			SET MYTHROTTLE TO 0.
		}
		ELSE {
			SET MYTHROTTLE TO 1.
		}
	}.
	
}.

PRINT "Orbiting in " + orbitSize + "m".

SET MYTHROTTLE TO 0.
SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.

UNLOCK THROTTLE.
UNLOCK STEERING.