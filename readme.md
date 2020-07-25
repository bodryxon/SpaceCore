# SpaceCore

A kOS Script Pack

Version 1.1.1

[License: MIT](GameData\SpaceCore\LICENSE.txt)

---

## What is it

SpaceCore is a pack of scripts for kOS mod to launch and operate your rockets. It is universal and can be used for most launch vehicles and spacecraft. You can use the scripts separately or combine them in your own flight programs.

I'm quite new to kOS and coding in general and the code may be far from perfect, but I am open to any recommendations.

If you've got any questions or ideas for new features, feel free to address them below.

## Installation

### [kOS] (required to run scripts)
--[KSP Forum](https://forum.kerbalspaceprogram.com/index.php?/topic/165628-181-kos-v1210-kos-scriptable-autopilot-system/&tab=comments#comment-3175111/)
--[SpaceDock](https://spacedock.info/mod/60/kOS:%20Scriptable%20Autopilot%20System)
--[GitHub](https://github.com/KSP-KOS/KOS/releases)

### SpaceCore
--[KSP Forum](https://forum.kerbalspaceprogram.com/index.php?/topic/194603-spacecore-kos-script-pack/)
--[SpaceDock](https://spacedock.info/mod/2447/SpaceCore%20kOS%20Script%20Pack)
--[GitHub](https://github.com/bodryxon/SpaceCore/releases)

Unzip the archive into your KSP folder. It can be done while KSP is running, there is no need to restart the game.

Before updating it is recommended to delete previous version of the pack.

## How to use

To use the scripts, you have to run them in kOS console like you would run any other kOS script. It is done by entering the command run <script name>.

---

### Example: Eject

    
    run Eject.
    

    Eject is the name of the script

Some scripts in the pack can be launched with specific parameters (orbit inclination, altitude etc.). It is done by entering the command run [script name]([parameter 1],[parameter 2]…).

---

### Example: SHohmann


    run SHohmann(100,120)


        100 is periapsis altitude
        120 is apoapsis altitude in kilometers

If you don't enter the parameters when running a script, default parameters will be used (they can be changed in script files).

Important: to run the scripts by "run" command you have to run dir.ks by entering   run dir.
