# customGear
`customGear` is a functionality included in GRAD Loadout that allows players to customize their loadout based on a set of options. By default a player can `ACE-Selfinteract >> Equipment >> Customize loadout`, for a certain time after his loadout was applied.

A player will only ever be able to choose between the options of a randomized item in his loadout. Let's say that this is his loadout (abbreviated):

```sqf
headgear = "SMM_Helmet_A_BW_FT";
uniform[] = {"U_C_man_sport_1_F", "U_BG_Guerilla2_1"};
primaryWeapon = "rhs_weap_hk416d10";
primaryWeaponOptics[] = {"rhsusf_acc_acog2_usmc","rhsusf_acc_acog3_usmc"};
```

Only the `uniform` and `primaryWeaponOptics` are randomized, so the player will only be able to choose from the available options in those two categories. This can be further restricted (but not expanded) with the `customGearAllowedCategories` parameter below.

## Configuration
There are a set of config parameters that can be used to define how `customGear` will behave (see [Configuration](configuration.md)).

### customGear
This parameter sets when exactly a player can access the `customGear` interface via his selfinteraction menu.

* -1 to disable entirely
* number to allow for this value in seconds after last loadout application
* statement to allow while this returns `true`, parameters are `[unit]`

**Example 1:**
```sqf
class Loadouts {
    // players can access the customGear interface for 5 minutes after last loadout application
    customGear = 300;
};
```

**Example 2:**
```sqf
class Loadouts {
    // players can access the customGear interface while closer than 100 to the BLUFOR respawn marker
    customGear = "(_this select 0) distance2D (getMarkerPos "respawn_west") < 100";
};
```

### customGearAllowedCategories
This parameter sets what categories players can customize (e.g. only vest and uniform). By default these are all supported categories.

**Example:**
```sqf
class Loadouts {
    // players can only customize uniform, vest, primary weapon and optic
    customGearAllowedCategories[] = {
        "uniform",
        "vest",
        "primaryWeapon",
        "primaryWeaponOptics"
    };
};
```

## Functions

### GRAD_Loadout_fnc_addCustomGearInteraction
This will add an interaction to an object to access the `customGear` interface. Note that the condition defined via the `customGear` parameter in your `description.ext` is not applied here. Effect is local.

Param | Type   | Default Value       | Description
------|--------|---------------------|----------------------------------------------------------------------------------------------------
0     | object | -                   | The object to attach the interaction to.
1     | code   | {true}              | Condition for this interaction to be available. Passed parameters [target object, caller]
2     | array  | ["ACE_MainActions"] | Action path. See also [ACE-Wiki](https://ace3mod.com/wiki/framework/interactionMenu-framework.html)

**Example:**
```sqf
[someObject, {WEST isEqualTo side (_this select 0)}, ["ACE_MainActions"]] call grad_loadout_fnc_addCustomGearInteraction
```

### GRAD_Loadout_fnc_setAllowedCategories
This will set the allowed customization categories on a per-unit basis. Effect is global.

Param | Type   | Default Value | Description
------|--------|---------------|-----------------------------------
0     | object | -             | The unit to set the categories of.
1     | array  | []            | Array of all allowed categories.

**Example:**
```sqf
// initServer.sqf
{
    [_x, ["vest", "uniform", "backpack", "headgear"]] call GRAD_Loadout_fnc_setAllowedCategories;
} forEach (playableUnits select {EAST isEqualTo side _x });
```

## Pictures

The `customGear` interface is reminiscent of BI's virtual arsenal:
![](https://i.imgur.com/FNN54BO.jpg)
