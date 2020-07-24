set WarpStopTime to 30. //custom value

clearscreen.

//display info
set running to true.
when running = true then {
	print "Apoapsis: "+round(apoapsis)+" m       " at (0,2).
	print "Periapsis: "+round(periapsis)+" m       " at (0,3).
	print "Time to apoapsis: "+round(eta:apoapsis)+"s       " at (0,4).
	print "Running: uCircToAp" at (0,6).
    preserve.
}


//staging
set InitialStageThrust to maxthrust.
when maxthrust<InitialStageThrust then {
	wait 1.
	stage.
		if maxthrust > 0 {
		set InitialStageThrust to maxthrust.
	}
	preserve.
}


wait until ship:q = 0.
	lock steering to prograde.
	set TargetV to ((body:mu)/(body:radius+apoapsis))^0.5.
	set ApoapsisV to (2*body:mu*((1/(body:radius+apoapsis))-(1/orbit:semimajoraxis/2)))^0.5.
	set BurnDeltaV to TargetV-ApoapsisV.
	set BurnTime to (BurnDeltaV*mass)/availablethrust.

wait 1.
rcs on.
sas off.
set warpmode to "rails".
print "Warping to apoapsis" at (0,0).
set BurnMoment to time:seconds + eta:apoapsis.
warpto(BurnMoment-BurnTime/2-WarpStopTime).

wait until vang(ship:facing:forevector,steering:forevector) <  5 and time:seconds > BurnMoment-BurnTime/2.
	set throttle to 1.
	print "Circularization burn started" at (0,0).

wait until TargetV < ship:velocity:orbit:mag.
	set throttle to 0.
	unlock steering.
	rcs off.
	print "Circularization burn completed" at (0,0).
	lock throttle to 0. unlock throttle.
	clearscreen.

rcs off.
sas on.
set running to false.
set ship:control:pilotmainthrottle to 0.
clearscreen.