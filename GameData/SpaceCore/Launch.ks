declare parameter FairingDeployment is false, TargetAltitudeKm is 75,RelativeInclinationDegr is 0, FairingDeploymentAltitudeKm is 60.

runpath("0:/SpaceCore/Countdown").

runpath("0:/SpaceCore/Liftoff").

runpath("0:/SpaceCore/Ascent",FairingDeployment,TargetAltitudeKm,RelativeInclinationDegr,FairingDeploymentAltitudeKm).

runpath("0:/SpaceCore/CircToAp").