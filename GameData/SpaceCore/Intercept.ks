//WORKS ONLY FOR PROGRADE ORBITS

declare parameter TargetPeriapsisKm is 200.

set WarpStopTime to 30. //custom value

set TPeriapsis to TargetPeriapsisKm*1000.

clearscreen.

print "Running: uIntercept" at (0,7).

print "Set target to proceed" at (0,0).
wait until hastarget.

until abs(target:orbit:inclination-ship:orbit:inclination) < 0.11 {
    print "Reduce relative inclination to 0.1 degrees or less to proceed" at (0,0).
    print "Current relative inclination: " + round(abs(target:orbit:inclination-ship:orbit:inclination),2) + " degrees       " at (0,3).
}
wait 2.
until abs(target:orbit:inclination-ship:orbit:inclination) < 0.11 {
    print "Reduce relative inclination to 0.1 degrees or less to proceed" at (0,0).
    print "Current relative inclination: " + round(abs(target:orbit:inclination-ship:orbit:inclination),2) + " degrees       " at (0,3).
}
clearscreen.

rcs on.
sas off.
set throttle to 0.

if orbit:eccentricity > 0.05 {
    runpath("0:/SpaceCore/CircToPe").
}

print "Running: uIntercept" at (0,7).

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


set TransferSMA to (max(apoapsis,target:apoapsis)+min(periapsis,target:periapsis))/2+body:radius.
set TransferTime to sqrt(4*constant:pi^2*TransferSMA^3/constant:g/body:mass)/2.

set ReqPhaseAngle to 180-360/target:orbit:period*TransferTime.
lock ShipAngle to obt:lan+obt:argumentofperiapsis+obt:trueanomaly.
lock TargetAngle to target:obt:lan+target:obt:argumentofperiapsis+target:obt:trueanomaly.
lock PhaseAngle to TargetAngle-ShipAngle-360*floor((TargetAngle-ShipAngle)/360).
set PhaseAngleRate to 360/target:orbit:period-360/orbit:period.

if orbit:semimajoraxis<target:orbit:semimajoraxis {
    lock Dir to prograde.
    lock dAngle to PhaseAngle-ReqPhaseAngle-360*floor((PhaseAngle-ReqPhaseAngle)/360).
}

else {
    lock Dir to retrograde.
    lock dAngle to ReqPhaseAngle-PhaseAngle-360*floor((ReqPhaseAngle-PhaseAngle)/360).
}

lock TimeToRPA to abs(dAngle/PhaseAngleRate).

set V to sqrt(body:mu/orbit:semimajoraxis).
set TV to sqrt(2*body:mu*((1/(body:radius+periapsis))-(1/TransferSMA/2))).
set dV to abs(TV-V).
set BurnTime to (dV*mass)/availablethrust.


wait 1.
lock steering to Dir.
set warpmode to "rails".
print "Warping to transfer burn point" at (0,0).
set BurnMoment to time:seconds + TimeToRPA.
warpto(BurnMoment-BurnTime/2-WarpStopTime).

wait until vang(ship:facing:forevector,steering:forevector) <  5 and time:seconds > BurnMoment-BurnTime/2.
	set throttle to 1.
    print "Burn started                  " at (0,0).

wait until ship:patches:tostring:contains("ORBIT of "+target:name).
    set throttle to 0.1.

wait until orbit:nextpatch:periapsis < TPeriapsis or orbit:nextpatch:inclination > 90.
   	set throttle to 0.
    print "Burn completed" at (0,0).

    rcs off.
    sas on.
	unlock steering.
	lock throttle to 0. unlock throttle.
	clearscreen.
    set ship:control:pilotmainthrottle to 0.
