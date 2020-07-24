declare parameter TargetPeKm.
set running to true.

set WarpStopTime to 30. //custom value 

set TargetPe to TargetPeKm*1000.

clearscreen.

//display info
when running = true then {
	print "Periapsis: "+round(periapsis)+" m       " at (0,2).
	print "Target periapsis: "+round(TargetPe)+" m       " at (0,3).
	print "Time to apoapsis: "+round(eta:apoapsis)+"s       " at (0,4).
	print "Running: uChangePe" at (0,6).
    preserve.
}



rcs on.
sas off.

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


if TargetPe = periapsis {
    set running to false.
}

if TargetPe < periapsis and running = true{
	set ApV to (2*body:mu*((1/(body:radius+apoapsis))-(1/orbit:semimajoraxis/2)))^0.5.
	set TApV to (2*body:mu*((1/(body:radius+apoapsis))-(1/(TargetPe+apoapsis+body:radius*2))))^0.5.
	set BurnDeltaV to ApV-TApV.
	set BurnTime to (BurnDeltaV*mass)/availablethrust.

	wait 1.
	lock steering to retrograde.
	set warpmode to "rails".
	print "Warping to apoapsis" at (0,0).
	set BurnMoment to time:seconds + eta:apoapsis.
	warpto(BurnMoment-BurnTime/2-WarpStopTime).

	wait until vang(ship:facing:forevector,steering:forevector) <  5 and time:seconds > BurnMoment-BurnTime/2.
		set throttle to 1.
		print "Burn started        " at (0,0).

	wait until ship:velocity:orbit:mag < TApV.
		set throttle to 0.
		print "Burn completed" at (0,0).

	set running to false.
	unlock steering.
	lock throttle to 0. unlock throttle.
	clearscreen.
}

if TargetPe > periapsis and running = true{
	set ApV to (2*body:mu*((1/(body:radius+apoapsis))-(1/orbit:semimajoraxis/2)))^0.5.
	set TApV to (2*body:mu*((1/(body:radius+apoapsis))-(1/(TargetPe+apoapsis+body:radius*2))))^0.5.
	set BurnDeltaV to TApV-ApV.
	set BurnTime to (BurnDeltaV*mass)/availablethrust.
		
	wait 1.
	lock steering to prograde.
	set warpmode to "rails".
	print "Warping to apoapsis" at (0,0).
	set BurnMoment to time:seconds + eta:apoapsis.
	warpto(BurnMoment-BurnTime/2-WarpStopTime).

	wait until vang(ship:facing:forevector,steering:forevector) <  5 and time:seconds > BurnMoment-BurnTime/2.
		set throttle to 1.
		print "Burn started        " at (0,0).

	wait until ship:velocity:orbit:mag > TApV.
		set throttle to 0.
		print "Burn completed" at (0,0).

	set running to false.
	unlock steering.
	lock throttle to 0. unlock throttle.
	clearscreen.
}

rcs off.
sas on.
set running to false.
set ship:control:pilotmainthrottle to 0.
clearscreen.