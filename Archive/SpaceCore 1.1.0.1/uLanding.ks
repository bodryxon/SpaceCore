declare parameter PreTouchdownAltitude is 30, ThrottleLevel is 0.8, LandingVelocity is 5.	//PreTouchdownAltitude - altitude of center of mass above the ground before TWR=1 descent 

clearscreen.
set running to true.

//display info
when running = true then {
	print "Radar altitude: "+round(alt:radar)+" m       " at(0,3).
	print "Velocity: "+round(velocity:surface:mag)+" m/s       " at (0,4).
	print "Vertical velocity: "+round(verticalspeed)+" m/s       " at (0,5).
	print "Horizontal velocity: "+round(groundspeed)+" m/s       " at (0,6).
	print "Running: uLanding" at (0,8).
    preserve.
}

sas off.
rcs on.
brakes on.
set throttle to 0.
lock steering to srfretrograde.


//landing burn start
wait until (ship:velocity:surface:mag^2/(2*alt:radar-PreTouchdownAltitude)+body:mu/(body:radius+altitude)^2)*mass > availablethrust*ThrottleLevel.
	set throttle to ThrottleLevel.
	print "Landing burn initiated" at (0,0).

lock throttle to (ship:velocity:surface:mag^2/(2*(alt:radar-PreTouchdownAltitude))+body:mu/(body:radius+altitude)^2)*mass/availablethrust.


//landing legs deployment
when alt:radar < 700 then{
	gear on.
}


//final descent
wait until ship:velocity:surface:mag < LandingVelocity.
	set TargetRoll to ship:facing:roll +90.
	lock steering to heading(90,90,TargetRoll).
	lock throttle to body:mu/(body:radius+altitude)^2*mass/availablethrust.

//landing
wait until status = "LANDED" or status = "SPLASHED" or verticalspeed > 0.
	set throttle to 0.
	print "Landing completed       " at (0,0).
	wait 5.
	unlock steering.
	sas on.
	lock throttle to 0. unlock throttle.
	set running to false.
	clearscreen.
	set ship:control:pilotmainthrottle to 0.