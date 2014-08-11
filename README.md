a3g-loadout
===========
An Arma 3 loadout system for mission makers

Setup
-----
- Make a folder inside your mission root folder, name it a3g-loadout.
- Put cfgfunctions.hpp and fn_loadout.sqf in it.
- Make a description.ext ( See what this is [here](https://community.bistudio.com/wiki/Description.ext) ) and put it in your mission root folder.
- Add this to it:
``` c++ 
class CfgFunctions { 
	#include "a3g-loadout\cfgfunctions.hpp" 
};
```
- Refer to How to make a loadout below.

Loadouts
--------
Loadouts are created using a class based structure, this has vast advantages over the commonly accepted method of scripting them on a per-unit basis.
The top entry point for a a loadout is the `CfgLoadout` class. Loadouts are written directly inside the description.ext and are applied _once_ on mission start. This is an example configuration that shows all the loadout options you have:
``` c++
class CfgLoadout {
	class B_Soldier_F {
		uniform = "kae_UN_Uniform_Armoured_P";
		// vest = "";
		// backpack = "";
		// magazines[] = {};
		// items[] = {};
		// addMagazines[] = {};
		addItems[] = {"AGM_Clacker", "AGM_Bandage"};
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
The loadouts work on a per-class basis, to create one you simply need to find out the classname of the unit ( this is available inside the editor for example ) and make it an entry in `CfgLoadout`. Changes inside now apply to all units of that class. You can of course have more than one class of units be represented with loadouts. Lists ( entries denoted with a `[]` ) expect an array as their input, even for a single entry. So make sure you don't forget to put them in `{}` and seperate the entries with a `,` like the example `addItems[]` above.

Options
-------
These are the different options can use for making a loadout, with a bit of an explanation of how they behave. The loadout options are completely modular, you can just use what you need and nothing more:

| Option                       | Explanation                                                                     |
| ---------------------------- | ------------------------------------------------------------------------------- |
| `uniform`                    | Replaces the uniform and preserves the items inside.                            |
| `vest`                       | Replaces the vest and preserves the items inside.                               |
| `backpack`                   | Replaces the backpack and preserves the items inside.                           |
| `magazines[]`                | Replaces all magazines from the _entire_ inventory with the ones listed.        |
| `items[]`                    | Replaces all Items from the _entire_ inventory with the ones listed.            |
| `addMagazines[]`             | Adds the provided list of magazines to the inventory without removing anything. |
|                              | Note that you can combine this option with the replacing variant above.         |
| `addItems[]`                 | Adds the provided list of items to the inventory without removing anything.     |
|                              | Note that you can combine this option with the replacing variant above.         |
| `headgear`                   | Replaces the headgear ( ie. helmet ).                                           |
| `goggles`                    | Replaces the goggles. Note that NVGoggles are not "goggles" in this context.    |
| `primaryWeapon`              | Replaces the primary weapon.                                                    |
| `secondaryWeapon`            | Replaces the secondary weapon ( ie. launcher ).                                 |
| `handgunWeapon`              | Replaces the handgun.                                                           |
| `primaryWeaponAttachments[]` | Replaces the attachments ( ie. scope ) of the primary weapon.                   |
| `handgunWeaponAttachments[]` | Replaces the attachments ( ie. scope ) of the handgun.                          |
