a3g-loadout
===========
An Arma 3 loadout system for mission makers.

Setup
-----
- Drag and drop the folder `a3g_loadout` into your mission root folder ( the folder that contains the mission.sqm ). It should look like this:
![](http://puu.sh/cQMZ8/16464b6ef1.png)
- Make a `description.ext` ( See what this is [here](https://community.bistudio.com/wiki/Description.ext) ) and put it in your mission root folder.
- Add this to it:
``` c++ 
class CfgFunctions { 
	#include "a3g_loadout\CfgFunctions.hpp" 
};
```
- Refer to `How to make a loadout` below.

Loadouts
--------
Loadouts are created using a priority based structure, this has vast advantages over the commonly accepted method of scripting them on a per-unit basis.
The top entry point for a a loadout is the `CfgLoadouts` class. Loadouts are written directly inside the `description.ext` and are applied _once_ on mission start. This is an example configuration that shows all the loadout options you have:
``` c++
class CfgLoadouts {
	class B_Soldier_F {
		linkedItems[] = {};
		uniform = "";
		backpack = "";
		vest = "";
		items[] = {};
		magazines[] = {};
		addItems[] = {};
		addMagazines[] = {};
		weapons[] = {};
		primaryWeapon = "";
		secondaryWeapon = "";
		handgunWeapon = "";
		primaryWeaponAttachments[] = {};
		handgunWeaponAttachments[] = {};
		headgear = "";	
		goggles = "";
		nvgoggles = "";
		binoculars = "";
		map = "";
		gps = "";
		compass = "";
		watch = "";
	};
};
```
The loadouts work on a priority basis, to create one you have several options. You can chose to apply them based on the unit class ( ie. so all medics get the same loadout ).
To do this you simply need to find out the classname of the unit ( this is available inside the editor for example ) and make it an entry in `CfgLoadouts`.
Changes inside now apply to all units of that class. You can of course have more than one class of units be represented with loadouts. Here is an example that illustrates this:
``` c++
class CfgLoadouts {
	class AV_IndUs_SL_Des {
		primaryWeapon = "RH_m4a1_ris";
		primaryWeaponAttachments[] = {"RH_ta31rco"};
	};
	class AV_IndUs_Asst_AR_Des {
		primaryWeapon = "RH_m4a1_ris";
	};
	class AV_IndUs_medic_Des {
		primaryWeapon = "RH_m4a1_ris";
	};
	class AV_IndUs_AT_Des {
		primaryWeapon = "RH_m4a1_ris";
	};
	class AV_IndUs_Marksman_M14_Des {
		primaryWeaponAttachments[] = {"optic_DMS"};
	};
	class AV_IndUs_REP_Des {
		primaryWeapon = "RH_m4a1_ris";
	};
	class AV_IndUs_AT_MAAWS_Des {
		primaryWeapon = "RH_m4a1_ris";
	};
};
```
Now where does the priority come into play? Simply put, you can combine several "layers" of loadout definitions. For example, let's say you want to give each unit a different weapon, EXCEPT the medic.
You can do this simply with:
``` c++
class CfgLoadouts {
	class Everyone {
		primaryWeapon = "some weapon classname";
	};
	class AV_IndUs_medic_Des {
		primaryWeapon = "some other weapon classname";
	};
};
```
This is all you have to do to give everyone a different weapon and give the medic a different weapon independent from the other guys. If you wanna further customize a unit, the script takes this into account and prioritizes special loadouts over generic ones. So the "everyone" loadout is
overwritten by class loadouts, and class loadouts are overwritten by unique loadouts.
This clearly shows how efficient this system is in changing multiple units at the same time ( in the mission this snippet is used, 18 units have their loadout set with this ), with almost no busywork involved.
Lists ( entries denoted with a `[]` ) expect an array as their input, even for a single entry. So make sure you don't forget to put them in `{}` and seperate the entries with a `,` like the example `addItems[]` above.

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
