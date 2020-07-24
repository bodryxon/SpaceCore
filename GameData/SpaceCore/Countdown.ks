set CheckForMovement to true. //set to false if you want the countdown to run in any situation

clearscreen.

print "Running: uCountdown" at (0,2).

set T to -10. //custom value



if CheckForMovement = true {

	if ship:velocity:surface:mag < 1 {
		until T>0 {
			print "T"+T+" seconds    " at(0,0).
			wait 1.
			set T to T+1.
		}
	}
}


if CheckForMovement = false {
	until T>0 {
		print "T"+T+" seconds    " at(0,0).
		wait 1.
		set T to T+1.
	}
}

clearscreen.