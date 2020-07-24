declare parameter FairingDeployment is false, TargetAltitudeKm is 75,RelativeInclinationDegr is 0, FairingDeploymentAltitudeKm is 60.

run uCountdown.

run uLiftoff.

run uAscent(FairingDeployment,TargetAltitudeKm,RelativeInclinationDegr,FairingDeploymentAltitudeKm).

run uCircToAp.