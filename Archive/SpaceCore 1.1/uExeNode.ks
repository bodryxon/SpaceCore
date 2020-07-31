set WarpStopTime to 30. //custom value

set Node to nextnode.
set BurnTime to (Node:deltav:mag*mass)/availablethrust.
set NodedV0 to Node:deltav.

clearscreen.

//display info
set running to true.
when running = true then {
    print "Total maneuver delta-V: "+ round(NodedV0:mag,1)+" m/s       " at (0,3).
    print "Remaining maneuver delta-V: "+round(Node:deltav:mag,1)+" m/s       " at (0,4).
    print "Running: uExeNode" at (0,6).
    preserve.
}


rcs on.
sas off.
set throttle to 0.


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


wait 1.
lock steering to Node:deltav.
set warpmode to "rails".
print "Warping to burn point" at (0,0).
set BurnMoment to time:seconds + Node:eta.
warpto(BurnMoment-BurnTime/2-WarpStopTime).

wait until vang(ship:facing:forevector,steering) <  1 and time:seconds > BurnMoment-BurnTime/2.
	lock throttle to 1.
    print "Burn started                  " at (0,0).

wait until Node:deltav:mag/NodedV0:mag < 0.05.
    lock throttle to 0.1.

wait until vdot(NodedV0, Node:deltav) < 0.
   	lock throttle to 0.
    print "Burn completed" at (0,0).

    rcs off.
    sas on.
	unlock steering.
	lock throttle to 0. unlock throttle.
    remove Node.
    set running to false.
	clearscreen.
    set ship:control:pilotmainthrottle to 0.