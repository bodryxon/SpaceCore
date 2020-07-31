declare parameter FairingDeployment is false, TargetAltitudeKm is 75,RelativeInclinationDegr is 0, FairingDeploymentAltitudeKm is 60.

runpath("0:/SpaceCore/uCountdown").

runpath("0:/SpaceCore/uLiftoff").

runpath("0:/SpaceCore/uAscent",FairingDeployment,TargetAltitudeKm,RelativeInclinationDegr,FairingDeploymentAltitudeKm).

runpath("0:/SpaceCore/uCircToAp").