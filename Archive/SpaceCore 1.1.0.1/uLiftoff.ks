set TimeAfterIgnition to 3.		//custom value

clearscreen.

print "Running: uLiftoff" at (0,2).

if maxthrust=0 {stage.}
set throttle to 1.
print "Ignition          " at (0,0).

wait TimeAfterIgnition.
if ship:velocity:surface:mag < 1 {stage.}
print "Liftoff!          " at (0,0).
wait 3.
clearscreen.