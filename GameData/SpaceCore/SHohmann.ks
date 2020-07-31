declare parameter Altitude1km, Altitude2km.
set running to true.

set WarpStopTime to 30.	//custom value

if Altitude1km > Altitude2km {
	set TargetAp to Altitude1km*1000.
	set TargetPe to Altitude2km*1000.
}

else {
	set TargetAp to Altitude2km*1000.
	set TargetPe to Altitude1km*1000.
}


if TargetAp = TargetPe and running = true {
    
    set TargetAlt to TargetAp.

    if TargetAlt > apoapsis and running = true {
        runpath("0:/SpaceCore/ChangeAp",TargetAlt/1000).
        runpath("0:/SpaceCore/ChangePe",TargetAlt/1000).
        set running to false.
    }

    if TargetAlt < apoapsis and running = true {
        runpath("0:/SpaceCore/ChangePe",TargetAlt/1000).
        runpath("0:/SpaceCore/ChangeAp",TargetAlt/1000).
        set running to false.
    }
}

else {

    if TargetPe > periapsis and running = true{
        runpath("0:/SpaceCore/ChangeAp",TargetAp/1000).
        runpath("0:/SpaceCore/ChangePe",TargetPe/1000).
        set running to false.
    }

    if TargetPe < periapsis and running = true{
        runpath("0:/SpaceCore/ChangePe",TargetPe/1000).
        runpath("0:/SpaceCore/ChangeAp",TargetAp/1000).
        set running to false. 
    }
}