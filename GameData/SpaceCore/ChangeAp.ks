declare parameter TargetApKm.
set running to true.

set WarpStopTime to 30. //custom value 

set TargetAp to TargetApKm*1000.

clearscreen.

//display info
when running = true then {
	print "Apoapsis: "+round(apoapsis)+" m       " at (0,2).
	print "Target apoapsis: "+round(TargetAp)+" m       " at (0,3).
	print "Time to periapsis: "+round(eta:periapsis)+"s       " at (0,4).
	print "Running: uChangeAp" at (0,6).
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


if TargetAp = apoapsis {
    set running to false.
}

if TargetAp < apoapsis and running = true{
	set PeV to (2*body:mu*((1/(body:radius+periapsis))-(1/orbit:semimajoraxis/2)))^0.5.
	set TPeV to (2*body:mu*((1/(body:radius+periapsis))-(1/(TargetAp+periapsis+body:radius*2))))^0.5.
	set BurnDeltaV to PeV-TPeV.
	set BurnTime to (BurnDeltaV*mass)/availablethrust.

	wait 1.
    lock steering to retrograde.
	set warpmode to "rails".
	print "Warping to periapsis" at (0,0).
	set BurnMoment to time:seconds + eta:periapsis.
	warpto(BurnMoment-BurnTime/2-WarpStopTime).

	wait until vang(ship:facing:forevector,steering:forevector) <  5 and time:seconds > BurnMoment-BurnTime/2.
		set throttle to 1.
		print "Burn started        " at (0,0).

	wait until ship:velocity:orbit:mag < TPeV.
		set throttle to 0.
		print "Burn completed" at (0,0).

	set running to false.
	unlock steering.
	lock throttle to 0. unlock throttle.
	clearscreen.
}

if TargetAp > apoapsis and running = true{
	set PeV to (2*body:mu*((1/(body:radius+periapsis))-(1/orbit:semimajoraxis/2)))^0.5.
	set TPeV to (2*body:mu*((1/(body:radius+periapsis))-(1/(TargetAp+periapsis+body:radius*2))))^0.5.
	set BurnDeltaV to TPeV-PeV.
	set BurnTime to (BurnDeltaV*mass)/availablethrust.
		
	wait 1.
    lock steering to prograde.
	set warpmode to "rails".
	print "Warping to periapsis" at (0,0).
	set BurnMoment to time:seconds + eta:periapsis.
	warpto(BurnMoment-BurnTime/2-WarpStopTime).

	wait until vang(ship:facing:forevector,steering:forevector) <  5 and time:seconds > BurnMoment-BurnTime/2.
		set throttle to 1.
		print "Burn started        " at (0,0).

	wait until ship:velocity:orbit:mag > TPeV.
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