a3g-loadout
===========
An Arma 3 loadout system for mission makers.

Setup
-----
- Drag and drop the folder `a3g_loadout` into your mission root folder ( the folder that contains the mission.sqm ). It should look like this:
- ![](http://puu.sh/cQMZ8/16464b6ef1.png)
- Make a `description.ext` ( See what this is [here](https://community.bistudio.com/wiki/Description.ext) ) and put it in your mission root folder.
- Add this to it:
``` c++ 
class CfgFunctions { 
	#include "a3g_loadout\CfgFunctions.hpp" 
};
```
- Read the `Loadouts` section below.

Loadouts
--------
Loadouts are created using a class based structure, defined directly in the mission config file. This has vast advantages over the commonly accepted method of scripting them on a per-unit basis.
The top entry point for a loadout is the `CfgLoadouts` class. Loadouts are applied _once_ on mission start, in order to not interfer with respawn systems. There are three priority systems that 
mission makers can use and freely combine with each other. More on that later. First of all, this is an example on how a loadout looks like with this system:
``` c++
class CfgLoadouts {
	class My_Cool_Unit {
		primaryWeapon = "RH_m4a1_ris";
		primaryWeaponAttachments[] = {"RH_ta31rco"};
	};
};
```
As you can see, they can be extremely simple, and contain only the information necessary to create the loadout. A loadout defining dozens of units can be done in as little 
as a couple lines of code. The simplest way of creating a loadout is to give units a name in the editor, ie. `unit_1` and define a class with the same name in the loadout 
section. Any changes done in that section now apply to that unit and that unit alone. The example above demonstrates this behavior, by reserving a loadout for a unit that 
carries the name `My_Cool_Unit` for the corresponding editor field.

The real power of this system becomes apparent if you factor the generics into account that it has access to. Instead of defining a loadout for each individual unit, you 
have the option to define it based on their unit class, or even for everyone at once all at the same time. Here is an example that demonstrates this from a mission that I 
made:
``` c++
class CfgLoadouts {
	class Everyone {
		primaryWeapon = "RH_m4a1_ris";
	};
	class AV_IndUs_SL_Des {
		primaryWeaponAttachments[] = {"RH_ta31rco"};
	};
	class AV_IndUs_Marksman_M14_Des {
		primaryWeapon = "RH_mk12mod1";
		primaryWeaponAttachments[] = {"RH_ta31rco"};
	};
};
```
This simple block of code changes and applies the loadout of 18 units at once, based on a few key instructions. Since the `Everyone` class is done first ( the actual order inside the block plays no role, 
the loadout for `Everyone` is always applied first ), followed by the class based loadouts and finally the individual loadouts, you can combine the different priority layers for some extremely tight 
loadout descriptions. We don't have to redefine a different primary weapon for the individual soldiers because the `Everyone` class already gives them each one. Note that the marksman class `AV_IndUs_Marksman_M14_Des` 
gets a different primary weapon, which is why we redefine it in his loadout, which overwrites the generic behavior of `Everyone`.
### Notes
- Unique loadouts ( targeting a specific unit ) overwrite class loadouts ( targeting all units of the same class ), which in turn overwrite `Everyone` loadouts ( targeting all units ).
- Unique loadouts are case _insensitive_, meaning `person`, `Person` and `perSon` all refer to the same unit.
- You can export a loadout directly from the virtual arsenal by pressing `CTRL`+`SHIFT`+`C`.
- You can modify a loadout exported from the arsenal with other options, see `Options` below.
- The order of options doesn't matter.
- The order of classes doesn't matter either.
- There's a caveat to using this system: You have to reload the mission everytime you change something inside the `description.ext` mission config file. Repeated previews do _not_ refresh it. In order to do it correctly, save the mission, then click the load mission button from the editor and select the mission you're currently editing, essentially loading the mission you're already editing. Due to caching this will typically take less than a second after the first time.

Options
-------
These are the different options can use for making a loadout, with a bit of an explanation of how they behave. 
The loadout options are completely modular, just use what you need and nothing more:

| Option                         | Explanation                                |
| ------------------------------ | ------------------------------------------ |
| `linkedItems[]`                | Replaces linked items. ( Arsenal export ). |
| `uniform`                      | Replaces uniform.                          |
| `backpack`                     | Replaces backpack.                         |
| `vest`                         | Replaces vest.                             |
| `items[]`                      | Replaces items.                            |
| `magazines[]`                  | Replaces magazines.                        |
| `addItems[]`                   | Adds items.                                |
| `addMagazines[]`               | Adds magazines.                            |
| `weapons[]`                    | Replaces weapons. ( Arsenal export ).      |
| `primaryWeapon`                | Replaces primary weapon.                   |
| `secondaryWeapon`              | Replaces secondary weapon.                 |
| `handgunWeapon`                | Replaces handgun.                          |
| `primaryWeaponAttachments[]`   | Replaces attachments of primary weapon.    |
| `secondaryWeaponAttachments[]` | Replaces attachments of secondary weapon.  |
| `handgunWeaponAttachments[]`   | Replaces attachments of handgun.           |
| `headgear`                     | Replaces headgear.                         |
| `goggles`                      | Replaces goggles.                          |
| `nvgoggles`                    | Replaces nightvision goggles.              |
| `binoculars`                   | Replaces binoculars.                       |
| `map`                          | Replaces map.                              |
| `gps`                          | Replaces gps.                              |
| `compass`                      | Replaces compass.                          |
| `watch`                        | Replaces watch.                            |

### Notes
- Array entries ( denoted with a `[]` ) require the array syntax, even when they are only used with a single item. The correct usage looks like this: `magazines[] = {"some_magazine_classname"};`.
- Single entries on the contrary look like this: `vest = "some_vest_classname";`. It is imperative that you do this right.
- All options default to removing the item(s) in question, if you leave the field empty, where it makes sense ( ie. `uniform = "";` ).
- `linkedItems[]` is used in conjunction with the arsenal export and should be avoided if inputting a loadout manually.
- `uniform`, `backpack` and `vest` options will try and preserve the items inside them, even if you change or completely remove them. 
	If you delete a backpack for example, the system will try and move them to the rest of your inventory, as long as there's space for them.
- `items[]` and `magazines[]` options will replace items / magazines from the _entire_ inventory.
- `addItems[]` and `addMagazines[]` options will add items / magazines without removing anything. This can be combined with `items[]` and `magazines[]`.
- `weapons[]` is used in conjunction with the arsenal export and should be avoided if inputting a loadout manually.
- `goggles` do _not_ replace nightvision goggles. There is a seperate option for it: `nvgoggles`. This is because nightvision goggles are their own independent slot.
- `secondaryWeapon` refers to a launcher, not a handgun. Refer to `handgun` for the latter.
- `secondaryWeaponAttachments[]` is not capable of removing attachments due to the lack of a proper scripting command for it.
- There is no option to replace the radio item. This is intentional, because both popular radio systems ( ACRE and TFR ) both need to change these items dynamically at 
	mission start. We want to avoid messing with these.
