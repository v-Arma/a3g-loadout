# GRAD Loadout, an improved [A3G Loadout](https://github.com/v-Arma/a3g-loadout)

Declarative loadout system for Arma3

## Acknowledgment

*As mentioned above, this is a continuation of mostly [Cephei](https://github.com/Cephel)'s work.*
*However, that project seems so dead and I changed so much that I saw it fit to rename repo & project. –– Fusselwurm, 2016-08-16*

## Prerequisites

* You should know what the `description.ext` is. If you don't, you can read about it [here](https://community.bistudio.com/wiki/Description.ext).
* You should know how to install mods.

## Dependencies

The [CBA_A3](https://github.com/CBATeam/CBA_A3) mod is required.

## Installation

### Manually

1. Create a folder in your mission root folder and name it `modules`. Then create one inside there and call it `grad-loadout`. If you want change the containing directory name you will have to adjust the MODULES_DIRECTORY definition, see [Configuration](#configuration)
2. Download the contents of this repository ( there's a download link at the side ) and put it into the directory you just created.
3. see step 3 below in the npm part

### Via `npm`

_for details about what npm is and how to use it, look it up on [npmjs.com](https://www.npmjs.com/)_

1. Install package `grad-loadout` : `npm install --save grad-loadout`
2. Prepend your mission's `description.ext` with `#define MODULES_DIRECTORY node_modules`
3. Append the following lines of code to the `description.ext`:

```sqf
class CfgFunctions {
  #include "node_modules\grad-loadout\CfgFunctions.hpp"
};
```

## Configuration

For large numbers of players that may overload the server with simultaneous loadout assignments, you may configure a custom delay for applying the loadout:

```sqf
class Loadouts {
    baseDelay = 10; // minimum time to wait after connect before applying loadout
    perPersonDelay = 1; // added random delay based on number of players
    handleRadios = 0; // if radios should be handled. defaults to 0
    resetLoadout = 1; // start with empty loadouts instead of modifying existing loadout
};
```

## Dynamic configuration

### GRAD_Loadout_Chosen_Prefix

You can, define a global var `GRAD_Loadout_Chosen_Prefix` – this will lead to grad-layout reading from a *subclass* of `Loadouts`. Example:


```sqf
// init.sqf:
`GRAD_Loadout_Chosen_Prefix = "Something_Something_Chosen_Prefix";`

// description.ext:
class Loadouts {
    class Something_Something_Chosen_Prefix {
        class AllUnits {
            // loadout value
        };
    };
};
```

### GRAD_Loadout_fnc_FactionSetLoadout

You can dynamically alias a faction name:

`["BLU_F", "USMC"] call GRAD_Loadout_fnc_FactionSetLoadout;` – thus, you can change loadout presets for your factions. In this example, this would work now:

```
class Loadouts {
    class Faction {
        class USMC {
            class AllUnits {
                backpack = "";
            };
        };
    };
};
```

### GRAD_Loadout_fnc_AddReviver

dynamically adjust loadout values. This example adds a bit of randomization to Russian helmets: 

```
[
    {
        _value = param [0];
        if (_value == "rhs_6b27m_digi") then {
            _value = selectRandom ["rhs_6b27m_digi", "rhs_6b27m_digi_bala"];
        };
        _value
    },
    "headgear"
] call GRAD_Loadout_fnc_addReviver;
```

## Loadouts

Loadouts are defined directly inside the `description.ext`. They are applied on mission start and when you respawn. This is an example on how a loadout looks like with this system:

```sqf
class Loadouts {
    class Rank {
        class Corporal {
            primaryWeapon = "RH_m4a1_ris";
            primaryWeaponOptics = "RH_ta31rco";
        };
    };
};
```

As you can see, they can be extremely simple, and contain only the information necessary to create the loadout. Due to the modular nature of the script, we're keeping most of the original loadout intact and are just changing the rifle and its weapon attachments. The simplest way of creating a loadout is to give units a name in the editor, ie. `My_Unit` and define a class with the same name in the loadout section in the `Name` subclass. Any changes done in that section now apply to that unit. The example above demonstrates this behavior, by reserving a loadout for a unit that carries the name `My_Unit`.

The real power of this system becomes apparent when you start combining different features for the desired effect. The modular nature of the script means you don't have to change anything that you don't actually want to change. If you just want to change a units uniform, you can just define a different uniform and everything else stays the same. Of course defining a loadout on a per-unit-basis would still be pretty lengthy and annoying. Instead you have the ability to use certain magical and not so magical classes to simplify the process. You can for example use the class of a unit, such as a Rifleman for example, which will then change the loadout of every unit that is of this class. The example below demonstrates this:

```sqf
class Loadouts {
    class AllPlayers {
        primaryWeapon = "RH_m4a1_ris";
    };
    class Type {
        class AV_IndUs_SL_Des {
            primaryWeaponOptics = "RH_ta31rco";
        };
        class AV_IndUs_Marksman_M14_Des {
            primaryWeapon = "RH_mk12mod1";
            primaryWeaponOptics = "RH_ta31rco";
        };
    };
};
```

This simple block of code changes and applies the loadout of 18 units at once, based on a few key instructions. Since the `AllPlayers` class is done first ( the actual order inside the block plays no role, the loadout for `AllPlayers` is always applied first ), followed by the class based loadouts and finally the individual loadouts, you can combine the different priority layers for some extremely tight loadout descriptions. We don't have to redefine a different primary weapon for the individual soldiers because the `AllPlayers` class already gives them each one. Note that the marksman class `AV_IndUs_Marksman_M14_Des` gets a different primary weapon, which is why we redefine it in his loadout, which overwrites the generic behavior of `AllPlayers`.

### Notes
- Unique loadouts ( targeting a specific unit ) overwrite class loadouts ( targeting all units of the same class ), which in turn overwrite `generic` loadouts ( targeting multiple units ).
- All loadouts are case _insensitive_, meaning `person`, `Person` and `perSon` all refer to the same unit, likewise, class definition and the `AllPlayers` class are also case insensitive. This is because Bohemia Interactive doesn't know how string comparisons should work.
- You can export a loadout directly from the virtual arsenal by pressing `CTRL`+`SHIFT`+`C`.
- You can modify a loadout exported from the arsenal with other options, see `Options` below.
- The order of options doesn't matter.
- The order of classes doesn't matter either.

### Important

There's a caveat to using this system: You have to reload the mission everytime you change something inside the `description.ext` mission config file. Repeated previews do _not_ refresh it. In order to do it correctly, save the mission, then click the load mission button from the editor and select the mission you're currently editing, essentially loading the mission you're already editing. Due to caching this will typically take less than a second after the first time. The reason is because Bohemia Interactive made it this way. There's nothing that can be done about it. Sorry.

## Classes

Loadouts are written inside classes. There are a couple of generic classes for you to use, ontop of being able to specifiy a unit classname and just designating a unit name. The priority in order is this:

* Loadouts/
    * AllUnits
    * AllAi
    * AllPlayable
    * AllPlayers
    * Side/
        * Blufor|Opfor|Independent|Civilian
        * BluforAi|OpforAi|IndependentAi|CivilianAi
        * BluforPlayer|OpforPlayer|IndependentPlayer|CivilianPlayer
    * Type/
        * class name, e.g. B_Soldier_F
    * Rank/
        * rank, e.g. CAPTAIN
    * Name/
        * editor name
    * Role/
        * unit role
    * Faction/
        * faction name, e.g. BLU_F . Aliasing possible, see`GRAD_Loadout_fnc_FactionSetLoadout`!
            * AllUnits
            * AllAi
            * AllPlayers
            * Type – here, the de-factionized type name, e.g. Soldier_F
            * Rank
            * Name

Loadout is read from top to bottom, and augemented/overwritten along the way.

## Generator getUnitLoadout-> grad-loadout
http://gruppe-adler.de/api/grad-loadout/

## More complete example

```sqf
class Loadouts {
    baseDelay = 1;
    perPersonDelay = 0;
    resetLoadout = 0;

    class AllPlayers {
        primaryWeapon = "RH_m4a1_ris";
    };
    class Side {
        class Opfor {
            nvg = "";
        };
        class BluforAi {
            items[] = "";
        };
    };
    class Type {
        class AV_IndUs_SL_Des {
            primaryWeaponOptics = "RH_ta31rco";
        };
    };
    class Name {
        class My_Unit {
            gps = "";
        };
    };
};
```

Respawn
-------
Works out of the box, 100% of the time, everytime.

Options
-------
These are the different options can use for making a loadout, with a bit of an explanation of how they behave.
The loadout options are completely modular, just use what you need and nothing more:

| Option                         | Explanation                                |
| ------------------------------ | ------------------------------------------ |
| `uniform`                      | Replaces uniform.                          |
| `backpack`                     | Replaces backpack.                         |
| `vest`                         | Replaces vest.                             |
| `addItemsToUniform[]`          | Adds items/magazines to the uniform.       |
| `addItemsToVest[]`             | Adds items/magazines to the vest.          |
| `addItemsToBackpack[]`         | Adds items/magazines to the backpack.      |
| `primaryWeapon`                | Replaces primary weapon.                   |
| `secondaryWeapon`              | Replaces secondary weapon.                 |
| `handgunWeapon`                | Replaces handgun.                          |
| `primaryWeaponMuzzle`          | Set muzzle attachment of primary weapon.   |
| `primaryWeaponOptics`          | Set scope of primary weapon.               |
| `primaryWeaponPointer`         | Set flashlight attachment of primary weapon|
| `primaryWeaponUnderbarrel`     | Set bipod/GL attachment of primary weapon. |
| `secondaryWeapon...`           | same as with primary weapon attachments.   |
| `handgunWeapon...`             | same as with primary weapon attachments.   |
| `headgear`                     | Replaces headgear.                         |
| `goggles`                      | Replaces goggles.                          |
| `nvgoggles`                    | Replaces nightvision goggles.              |
| `binoculars`                   | Replaces binoculars.                       |
| `map`                          | Replaces map.                              |
| `gps`                          | Replaces gps.                              |
| `compass`                      | Replaces compass.                          |
| `watch`                        | Replaces watch.                            |
| `radio`                        | Replaces radio (set also `handleRadios`!)  |

### Notes

- Array entries ( denoted with a `[]` ) require the array syntax, even when they are only used with a single item. The correct usage looks like this: `addItemsToUniform[] = {"some_classname"};`.
- Single entries on the contrary look like this: `vest = "some_vest_classname";`. It is imperative that you do this right, because the editor crashes if you mess this up. You can thank Bohemia Interactive for that.
- All options default to removing the item(s) in question, if you leave the field empty ( ie. `uniform = "";` ).
- `uniform`, `backpack` and `vest` options will try and preserve the items inside them, even if you change or completely remove them. If you delete a backpack for example, the system will try and move them to the rest of your inventory, as long as there's space for them. This obviously has its limit. If you remove almost all containers, then some items will be lost. This is your own responsibility.
- `goggles` do _not_ replace nightvision goggles. There is a seperate option for it: `nvgoggles`. This is because nightvision goggles are their own independent slot.
- `secondaryWeapon` refers to a launcher, not a handgun. Refer to `handgunWeapon` for the latter.
- You can get the amount of times a loadout has been applied to a specific unit using `unit getVariable ["GRAD_loadout_applicationCount", 0];`

### Important

Support for `linkedItems[]` , `weapons[]` , `items[]`,  `magazines[]`, `addItems[]` and `addMagazines[]` has been dropped with version 4.x , due to the amount of work it would've required to make it work with `getUnitLoadout/setUnitLoadout` .

# Roadmap

There's some changes I want to change, chiefly reduce the number of config classes that are being read:

## Old selectors

* AllUnits
* AllAi {!(isPlayer _unit)}
* AllPlayable {_unit in playableUnits}
* AllPlayers {isPlayer _unit}
* AllUnits >> Type >> typeof _unit
* AllAi >> Type >> typeof _unit
* AllPlayable >> Type >> typeof _unit
* AllPlayers >> Type >> typeof _unit
* Blufor {side _unit == blufor}
* Opfor {side _unit == opfor}
* Independent {side _unit == independent}
* Civilian {side _unit == civilian}
* BluforAi { side _unit == blufor && { !isPlayer _unit }}
* OpforAi { side _unit == opfor && { !isPlayer _unit }}
* IndependentAi { side _unit == independent && { !isPlayer _unit }}
* CivilianAi { side _unit == civilian && { !isPlayer _unit }}
* BluforPlayers { side _unit == blufor && { isPlayer _unit }}
* OpforPlayers { side _unit == opfor && { isPlayer _unit }}
* IndependentPlayers { side _unit == independent && { isPlayer _unit }}
* CivilianPlayers { side _unit == civilian && { isPlayer _unit }}
* Type >> typeof _unit
* Rank >> rank _unit
* Name >> (str _unit splitString "_" select 0)
* Role >> ([roleDescription _unit] call BIS_fnc_filterString);

## New selectors

* AllUnits
* AllAi
* AllPlayers
* Blufor {side _unit == blufor}
* Opfor {side _unit == opfor}
* Independent {side _unit == independent}
* Civilian {side _unit == civilian}
* Type >> typeof _unit
* Rank >> rank _unit
* Name >> (str _unit splitString "_" select 0)
* Role >> ([roleDescription _unit] call BIS_fnc_filterString);
* Faction >> ([_unit] call GRAD_Loadout_FactionGetLoadout)
	* AllUnits
	* AllAi
	* AllPlayers
	* Type >> ([typeof _unit] call GRAD_Loadout_DeFactionizeType)
	* Rank >> rank _unit
	* Role >> ([roleDescription _unit] call BIS_fnc_filterString);
