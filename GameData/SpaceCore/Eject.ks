declare parameter TargetAltitudeKm.     //altitude of one of the apsis of target orbit (the second one is semi-major axis of the body you are departing from)

set WarpStopTime to 30. //custom value

set TargetAlt to TargetAltitudeKm*1000.

if orbit:inclination > 10 {
    runpath("0:/SpaceCore/ChangeInc",0).
}

if orbit:eccentricity > 0.05 {
    runpath("0:/SpaceCore/CircToPe").
}

clearscreen.
print "Running: uEject" at (0,7).

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



//calculations

function BPA {       //body prograde angle - basically what has to be equal to an ejection angle
    local BPAPure is 90-(body:orbit:velocity:orbit:direction-velocity:orbit:direction):yaw.
    if BPAPure < 0 {
        set BPAPure to BPAPure + 360.
    }
    return BPAPure.
}


set TargetV to sqrt(2*(body:body:mu/body:orbit:semimajoraxis-body:body:mu/(TargetAlt+body:body:radius+body:orbit:semimajoraxis))).
set BodyV to abs(TargetV-body:orbit:velocity:orbit:mag).
set SpecMechEnEsc to BodyV^2/2-body:mu/body:soiradius. 
set VDep to sqrt(2*(body:mu/orbit:semimajoraxis+SpecMechEnEsc)).
set EscV to sqrt(2*(body:mu/orbit:semimajoraxis-body:mu/(orbit:semimajoraxis+body:soiradius))).
if EscV > VDep {
    set VDep to EscV.
}
set EjdV to VDep-velocity:orbit:mag.
set BurnTime to (EjdV*mass)/availablethrust.


set SpecMechEn to VDep^2/2-body:mu/orbit:semimajoraxis.
set HypSMA to -body:mu/2/SpecMechEn.
set Ecc to 1-orbit:semimajoraxis/HypSMA.
set EjAngle to arcsin(1/Ecc)+90.
if TargetAlt+body:body:radius < body:orbit:semimajoraxis {
    set EjAngle to EjAngle+180.
}

if EjAngle > 360 {
    set EjAngle to 360-EjAngle.
}


set TAOffset to BPA-(360-orbit:trueanomaly).
if TAOffset < 0 {
    set TAOffset to TAOffset+360.
}

set EjTA to 360-(EjAngle-TAOffset).
if EjTA < 0 {
    set EjTa to EjTa+360.
}

set EjEccA to 2*arctan(tan(EjTA/2)/sqrt((1+orbit:eccentricity)/(1-orbit:eccentricity))).
if EjEccA<0 {
	set EjEccA to EjEccA+360.
}

set EjMA to EjEccA - orbit:eccentricity*sin(EjEccA)*180/constant:pi.
if EjMA<0 {
	set EjMA to EjMA+360.
}


set TimeToBurn to ship:orbit:period/360*(EjMA-orbit:meananomalyatepoch).
if TimeToBurn<0 {
    set TimeToBurn to TimeToBurn + orbit:period.
}




//burn

clearscreen.
rcs on.
sas off.

wait 1.
lock steering to prograde.
set warpmode to "rails".
print "Warping to burn moment" at (0,0).
set BurnMoment to time:seconds + TimeToBurn.
warpto(BurnMoment-BurnTime/2-WarpStopTime).

wait until vang(ship:facing:forevector,steering:forevector) <  5 and time:seconds > BurnMoment-BurnTime/2.
	set throttle to 1.
    print "Burn started                  " at (0,0).


if TargetAlt < body:altitude + body:body:radius {
    wait until ship:patches:tostring:contains("ORBIT of "+body:body:name) and orbit:nextpatch:periapsis < TargetAlt.
}

if TargetAlt > body:altitude + body:body:radius {
    wait until ship:patches:tostring:contains("ORBIT of "+body:body:name) and orbit:nextpatch:apoapsis > TargetAlt.
}


set throttle to 0.
print "Burn completed" at (0,0).

rcs off.
sas on.
unlock steering.
lock throttle to 0. unlock throttle.
clearscreen.
set ship:control:pilotmainthrottle to 0.
