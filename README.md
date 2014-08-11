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
The top entry point for a a loadout is the `CfgLoadout` class. Loadouts are written directly inside the description.ext and are applied _once_ on mission start. This is an example configuration that shows all the loadout options you have:
``` c++
class CfgLoadout {
	class B_Soldier_F {
		uniform = "kae_UN_Uniform_Armoured_P";		// Changes the uniform
		// vest = "";						// Changes the vest
		// backpack = "";				// Changes the backpack
		// magazines[] = {"30Rnd_556x45_Stanag_Tracer_Red", "30Rnd_556x45_Stanag_Tracer_Red"}; // Replaces magazines with the ones listed here
		// items[] = {};				// Replaces items with the ones listed here
		// addMagazines[] = {};				// Does not replace magazines, just adds them ontop of the default loadout
		addItems[] = {"AGM_Clacker"};			// Does not replace items, just adds them ontop of the default loadout
		// headgear = "";				// Replaces headgear	
		// goggles = "";				// Replaces goggles
		primaryWeapon = "RH_m4a1_ris";			// Replaces the primary weapon	
		// secondaryWeapon = "";			// Replaces the secondary weapon ( launcher )		
		// handgunWeapon = "RH_m9";			// Replaces the handgun
		primaryWeaponAttachments[] = {"RH_ta31rco"};	// Replaces the primary weapon attachments ( ie. scopes )
		// handgunWeaponAttachments[] = {};		// Replaces the handgun attachments ( ie. scopes )
	};
};
```
The loadouts work on a per-class basis, to create one you simply need to find out the classname of the unit ( this is available inside the editor for example ) and make it an entry in CfgLoadout. Changes now apply to all units of that class.
