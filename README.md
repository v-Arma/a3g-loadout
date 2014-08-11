a3g-loadout
===========
An Arma 3 loadout system for mission makers

Setup
-----
- Make a folder inside your mission root folder, name it a3g-loadout
- Put cfgfunctions.hpp and fn_loadout.sqf in it
- Make a description.ext ( See what this is [here](https://community.bistudio.com/wiki/Description.ext) )
- Add
``` c++ 
class CfgFunctions { 
	#include "a3g-loadout\cfgfunctions.hpp" 
};
```
- Refer to How to make a loadout below

Loadouts
--------
Loadouts are created using a class based structure, this has vast advantages over the commonly accepted method of scripting them on a per-unit basis.
The top entry point for a a loadout is the `CfgLoadout` class. Loadouts are written directly inside the description.ext and are applied _once_ on mission start.
``` c++
class CfgLoadout {
	class B_Soldier_F {
		// uniform = "kae_UN_Uniform_Armoured_P";
		// vest = "";
		// backpack = "";
		// magazines[] = {"30Rnd_556x45_Stanag_Tracer_Red", "30Rnd_556x45_Stanag_Tracer_Red"};
		// items[] = {};
		// addMagazines[] = {};
		addItems[] = {"AGM_Clacker"};
		// headgear = "";
		// goggles = "";
		primaryWeapon = "RH_m4a1_ris";		
		// secondaryWeapon = "";		
		// handgunWeapon = "RH_m9";
		primaryWeaponAttachments[] = {"RH_ta31rco"};
		// handgunWeaponAttachments[] = {};
	};
};
```
