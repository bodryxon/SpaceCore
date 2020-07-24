set better to 1.
declare parameter TInc, WhichNode is better.    //better if more efficient, closer if faster.

set WarpStopTime to 30. //custom value
set IncAccuracy to 0.1. //custom value

set running to true.
set closer to 123.

clearscreen.

//display info
when running = true then {
	print "Inclination: "+round(orbit:inclination,1)+" degrees       " at (0,2).
	print "Target inclination: "+round(TInc,1)+" degrees       " at (0,3).
	print "Running: uChangeInc" at (0,5).
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


//calculations

lock Inc to orbit:inclination.

set ANTrA to 360-orbit:argumentofperiapsis.
set DNTrA to ANTrA + 180.
if DNTrA >= 360 {
    set DNTrA to DNTrA-360.
}

set ANEccA to 2*arctan(tan(ANTrA/2)/sqrt((1+orbit:eccentricity)/(1-orbit:eccentricity))).
if ANEccA<0 {
	set ANEccA to ANEccA+360.
}
set DNEccA to 2*arctan(tan(DNTrA/2)/sqrt((1+orbit:eccentricity)/(1-orbit:eccentricity))).
if DNEccA<0 {
	set DNEccA to DNEccA+360.
}

set ANMA to ANEccA - orbit:eccentricity*sin(ANEccA)*180/constant:pi.
if ANMA<0 {
	set ANMA to ANMA+360.
}
set DNMA to DNEccA - orbit:eccentricity*sin(DNEccA)*180/constant:pi.
if DNMA<0 {
	set DNMA to DNMA+360.
}

set ANAlt to orbit:semimajoraxis*(1-orbit:eccentricity^2)/(1+orbit:eccentricity*cos(ANTrA)).
set DNAlt to orbit:semimajoraxis*(1-orbit:eccentricity^2)/(1+orbit:eccentricity*cos(DNTrA)).

set ANV to sqrt(2*body:mu*((1/ANAlt)-(1/orbit:semimajoraxis/2))).
set DNV to sqrt(2*body:mu*((1/DNAlt)-(1/orbit:semimajoraxis/2))).

set ANdV to 2*sin(abs(TInc-Inc)/2)*ANV.
set DNdV to 2*sin(abs(TInc-Inc)/2)*DNV.

set dV to min(ANdV,DNdV).
set BurnTime to (dV*mass)/availablethrust.

function TimeToAN {
    local TimeToANPure is ship:orbit:period/360*(ANMA-orbit:meananomalyatepoch).
    if TimeToANPure<0 {
        set TimeToANPure to TimeToANPure + orbit:period.
    }

    return TimeToANPure.
}

function TimeToDN {
    local TimeToDNPure is ship:orbit:period/360*(DNMA-orbit:meananomalyatepoch).
    if TimeToDNPure<0 {
        set TimeToDNPure to TimeToDNPure + orbit:period.
    }

    return TimeToDNPure.
}

//burn

rcs on.
sas off.

if WhichNode = better {
    if ANdV<DNdV {
        lock steering to vcrs(ship:velocity:orbit,body:position).
	    set warpmode to "rails".
	    print "Warping to ascending node" at (0,0).
		set BurnMoment to time:seconds + TimeToAN.
	    warpto(BurnMoment-BurnTime/2-WarpStopTime).

	    wait until vang(ship:facing:forevector,steering) <  5 and time:seconds > BurnMoment-BurnTime/2.
	    	set throttle to 1.
		    print "Burn started             " at (0,0).

		wait until abs(TInc-Inc)<=IncAccuracy*10.
	    	set throttle to 0.1.

	    wait until abs(TInc-Inc)<=IncAccuracy.
	    	set throttle to 0.
		    print "Burn completed" at (0,0).
    }

    if DNdV<ANdV {
        lock steering to vcrs(ship:velocity:orbit,-body:position).
	    set warpmode to "rails".
	    print "Warping to descending node" at (0,0).
	    set BurnMoment to time:seconds + TimeToDN.
	    warpto(BurnMoment-BurnTime/2-WarpStopTime).

	    wait until vang(ship:facing:forevector,steering) <  5 and time:seconds > BurnMoment-BurnTime/2.
	    	set throttle to 1.
		    print "Burn started              " at (0,0).

		wait until abs(TInc-Inc)<=IncAccuracy*10.
	    	set throttle to 0.1.

	    wait until abs(TInc-Inc)<=IncAccuracy.
	    	set throttle to 0.
		    print "Burn completed" at (0,0).
    }
	set running to false.
}


if running = true and WhichNode = closer {
	if TimeToAN < TimeToDN {
        lock steering to vcrs(ship:velocity:orbit,body:position).
	    set warpmode to "rails".
	    print "Warping to ascending node" at (0,0).
	    set BurnMoment to time:seconds + TimeToAN.
	    warpto(BurnMoment-BurnTime/2-WarpStopTime).

	    wait until vang(ship:facing:forevector,steering) <  5 and time:seconds > BurnMoment-BurnTime/2.
	    	set throttle to 1.
		    print "Burn started             " at (0,0).

		wait until abs(TInc-Inc)<=IncAccuracy*10.
	    	set throttle to 0.1.

	    wait until abs(TInc-Inc)<=IncAccuracy.
	    	set throttle to 0.
		    print "Burn completed" at (0,0).
    }

    if TimeToAN > TimeToDN {
        lock steering to vcrs(ship:velocity:orbit,-body:position).
	    set warpmode to "rails".
	    print "Warping to descending node" at (0,0).
		set BurnMoment to time:seconds + TimeToDN.
	    warpto(BurnMoment-BurnTime/2-WarpStopTime).

	    wait until vang(ship:facing:forevector,steering) <  5 and time:seconds > BurnMoment-BurnTime/2.
	    	set throttle to 1.
		    print "Burn started              " at (0,0).

		wait until abs(TInc-Inc)<=IncAccuracy*10.
	    	set throttle to 0.1.

	    wait until abs(TInc-Inc)<=IncAccuracy.
	    	set throttle to 0.
		    print "Burn completed" at (0,0).
    }
}


if WhichNode <> better and WhichNode <> closer {
	print "WhichNode parameter has to be 'better' or 'closer'" at (0,0).
	wait 5.
}

lock throttle to 0. unlock throttle.
unlock steering.
set running to false.
clearscreen.
set ship:control:pilotmainthrottle to 0.