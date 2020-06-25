# Creating Loadouts
Loadouts are defined in the `Loadouts` class in your `description.ext`. If you don't want to read all this, there is also a [generator here](http://gruppe-adler.de/api/grad-loadout/).

**Short Example:**
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

## Debugging
To see if your loadouts were applied correctly, you can use the chat command `#grad-loadout viewer` to open the loadoutViewer and inspect all units.
To check all currently loaded loadouts, you can use the chat command `#grad-loadout verify`. This will test the loadouts of all units currently in the game and output errors and warning to your rpt file.

## Randomization
If you are defining an array where you would usually expect a single item (e.g. `uniform`, `primaryWeapon`, etc.) a random item of the array will be selected on a per-unit basis, if not disabled by config or script (see [GRAD_Loadout_fnc_setRandomizationMode](functions.md#GRAD_Loadout_fnc_setRandomizationMode) and [Configuration](configuration.md)).

**Example:**
```sqf
class AllUnits {
	uniform[] = {"U_C_man_sport_1_F", "U_BG_Guerilla2_1"};
};
```

## Options
These are the different options can use for making a loadout, with a bit of an explanation of how they behave.
The loadout options are completely modular, just use what you need and nothing more:

| Option                             | Explanation                                                                      |
|------------------------------------|----------------------------------------------------------------------------------|
| `uniform`                          | Replaces uniform.                                                                |
| `backpack`                         | Replaces backpack.                                                               |
| `vest`                             | Replaces vest.                                                                   |
| `addItemsToUniform[]`              | Adds items/magazines to the uniform.                                             |
| `addItemsToVest[]`                 | Adds items/magazines to the vest.                                                |
| `addItemsToBackpack[]`             | Adds items/magazines to the backpack.                                            |
| `primaryWeapon`                    | Replaces primary weapon.                                                         |
| `secondaryWeapon`                  | Replaces secondary weapon.                                                       |
| `handgunWeapon`                    | Replaces handgun.                                                                |
| `primaryWeaponMagazine`            | Set loaded magazine for primary weapon.                                          |
| `primaryWeaponMuzzle`              | Set muzzle attachment of primary weapon.                                         |
| `primaryWeaponOptics`              | Set scope of primary weapon.                                                     |
| `primaryWeaponPointer`             | Set flashlight attachment of primary weapon                                      |
| `primaryWeaponUnderbarrel`         | Set bipod/GL attachment of primary weapon.                                       |
| `primaryWeaponUnderbarrelMagazine` | Set loaded GL magazine of primary weapon.                                        |
| `secondaryWeapon...`               | same as with primary weapon attachments.                                         |
| `handgunWeapon...`                 | same as with primary weapon attachments.                                         |
| `headgear`                         | Replaces headgear.                                                               |
| `goggles`                          | Replaces goggles.                                                                |
| `nvgoggles`                        | Replaces nightvision goggles.                                                    |
| `binoculars`                       | Replaces binoculars.                                                             |
| `map`                              | Replaces map.                                                                    |
| `gps`                              | Replaces gps.                                                                    |
| `compass`                          | Replaces compass.                                                                |
| `watch`                            | Replaces watch.                                                                  |
| `radio`                            | Replaces radio (set also `handleRadios`, see [Configuration](configuration.md) ) |

## Classes
There are a couple of generic classes for you to use, ontop of being able to specify a unit classname and just designating a unit name. The priority in order is this:

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
        * faction name, e.g. BLU_F . Aliasing possible, see [GRAD_Loadout_fnc_FactionSetLoadout](functions.md#GRAD_Loadout_fnc_factionSetLoadout)!
            * AllUnits
            * AllAi
            * AllPlayers
            * Type – here, the de-factionized type name, e.g. Soldier_F
            * Rank
            * Name

Loadout is read from top to bottom, and augemented/overwritten along the way.

## Special Case: Using "Faction"
Most of the classes mentioned above are self explanatory, but a few words need to be said about the `Faction` class:

`Faction` allows you to create `typeOf` unit based loadouts that can then be dynamically assigned to any of the three main vanilla faction (NATO, CSAT, AAF) - this is shown in the [Complete Example](creatingLoadouts.md#Complete-Example). For this to work, you need to use the *defactionized* type of a unit, so instead of `B_Soldier_F` (which is a BLUFOR rifleman) you would use `Soldier_F` (which is any rifleman).

Grad-Loadout will check if a unit can be defactionized and then check if an applicable loadout exists. If Grad-Loadout encounters a unit that can not be defactionized (i.e. a unit that is not one of the three vanilla factions), it will instead look for its full `typeOf` name.

**Example 1:**
```sqf
// initServer.sqf
// the "MyLoadout" loadouts class is assigned to both the BLU_F and gmx_fc_tak factions
["BLU_F", "MyLoadout", true] call GRAD_Loadout_fnc_factionSetLoadout;
["gmx_fc_tak", "MyLoadout", true] call GRAD_Loadout_fnc_factionSetLoadout;
```

```sqf
class Loadouts {
    class Faction {
        class MyLoadout {
            class Type {
                // a NATO (BLU_F) Rifleman will receive this loadout
                class Soldier_F {
                    // Soldier_F loadout
                };

                // a Takistan Army (gmx_fc_tak) Rifleman will receive this loadout
                class gmx_tak_army_rifleman: Soldier_F {};
            };
        };
    };
};
```

## Special Case: Weapons in backpacks
If you want to add a weapon to a backpack, simply add the weapon's classname to `addItemsToBackpack` like you would with any other item. However, if you want the weapon to have attachments and/or loaded magazines, the config has to look like the following examples. Note that the weapon class has to be inside the same parent class as the `addItemsToBackpack` property where it is used.

**Example 1:**
```sqf
addItemsToBackpack[] = {"arifle_Mk20C_F", ...};
class arifle_Mk20C_F {
    muzzle = "";
    pointer = "";
    optics = "";
    magazine = "30Rnd_556x45_Stanag";
    underBarrelMagazine = "";
    underBarrel = "";
};
```

**Example 2:**
```sqf
addItemsToBackpack[] = {"FancySchmazyWeapon", ...};
class FancySchmazyWeapon {
    weapon = "arifle_Mk20C_F";
    muzzle = "";
    pointer = "";
    optics = "";
    magazine = "30Rnd_556x45_Stanag";
    underBarrelMagazine = "";
    underBarrel = "";
};
```

## Complete Example
In this example the vanilla `BLU_F` faction is being used for US OCP loadouts. All units of this faction will have the OCP uniform, vest and an M4A1 primary weapon as well as a number of other items. The Rifleman (Type `Soldier_F`) is then assigned uniform and vest contents, which will be used for other roles via inheritance. For example the Assistant Autorifleman will have the same loadout as the standard Rifleman, but with an added backpack. The Autorifleman will then overwrite the `primaryWeapon` assigned in `AllUnits` to use an LMG instead. The `vest` contents that he inherits from the Rifleman will also be overwritten.

Note that a `LIST` macro is utilized here, which can be found [here](https://github.com/gruppe-adler/grad-factions/blob/master/list_macros.hpp).

```sqf
// initServer.sqf
["BLU_F", "USOCP", true] call GRAD_Loadout_fnc_factionSetLoadout;
```

```sqf
//description.ext
class Loadouts {
    class Faction {
        class USOCP {
            class AllUnits {
                uniform = "rhs_uniform_cu_ocp";
                vest = "rhsusf_iotv_ocp_Rifleman";
                backpack = "";
                headgear = "rhsusf_ach_helmet_ocp";
                primaryWeapon = "rhs_weap_m4a1_blockII_bk";
                primaryWeaponMagazine = "30Rnd_556x45_Stanag";
                primaryWeaponOptics = "rhsusf_acc_g33_T1";
                primaryWeaponUnderbarrel = "";
        		primaryWeaponUnderbarrelMagazine = "";
                secondaryWeapon = "";
                secondaryWeaponMagazine = "";
                handgunWeapon = "rhsusf_weap_m9";
                handgunWeaponMagazine = "rhsusf_mag_15Rnd_9x19_JHP";
                binoculars = "Binocular";
                map = "ItemMap";
                compass = "ItemCompass";
                watch = "ItemWatch";
                gps = "ItemGPS";
                radio = "tfar_anprc152";
            };

            class Type {
                //Rifleman
                class Soldier_F {
                    addItemsToUniform[] = {
                        LIST_1("ACE_MapTools"),
                        LIST_1("ACE_DefusalKit"),
                        LIST_2("ACE_CableTie"),
                        LIST_1("ACE_Flashlight_MX991"),

                        LIST_4("ACE_packingBandage"),
                        LIST_4("ACE_elasticBandage"),
                        LIST_4("ACE_quikclot"),
                        LIST_4("ACE_tourniquet"),
                        LIST_2("ACE_morphine"),
                        LIST_2("ACE_epinephrine")
                    };
                    addItemsToVest[] = {
                        LIST_2("HandGrenade"),
                        LIST_2("SmokeShell"),
                        LIST_2("rhsusf_mag_15Rnd_9x19_JHP"),
                        LIST_7("30Rnd_556x45_Stanag")
                    };
                };

                //Asst. Autorifleman
                class soldier_AAR_F: Soldier_F {
                    backpack = "rhsusf_assault_eagleaiii_ocp";
                    addItemsToBackpack[] = {
                        LIST_2("rhs_200rnd_556x45_M_SAW"),
                        "rhsusf_100Rnd_556x45_soft_pouch"
                    };
                };

                //Autorifleman
                class soldier_AR_F: Soldier_F {
                    primaryWeapon = "rhs_weap_m249_pip_S";
                    primaryWeaponMagazine = "rhs_200rnd_556x45_M_SAW";
                    handgunWeapon = "";
                    handgunWeaponMagazine = "";
                    vest = "rhsusf_iotv_ocp_SAW";
                    backpack = "rhsusf_assault_eagleaiii_ocp";
                    addItemsToBackpack[] = {
                        LIST_2("rhs_200rnd_556x45_M_SAW"),
                        "rhsusf_100Rnd_556x45_soft_pouch"
                    };
                    addItemsToVest[] = {
                        LIST_2("HandGrenade"),
                        LIST_2("SmokeShell")
                    };
                };

            };
        };
    };
};
```
