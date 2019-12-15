# Functions

## GRAD_Loadout_fnc_factionSetLoadout
You can dynamically alias a faction name and optionally broadcast it over network (parameter 2, bool):

Param | Type   | Default Value | Description
------|--------|---------------|--------------------------------------------------------------------------------------------
0     | string | -             | Faction name. Get this with [faction](https://community.bistudio.com/wiki/faction) command.
1     | string | -             | Loadout classname.
2     | bool   | false         | Set to true for global effect (`publicVariable`).


**Example:**
```sqf
// initServer.sqf - Set BLU_F faction to use USMC loadout.
["BLU_F", "USMC", true] call GRAD_Loadout_fnc_factionSetLoadout;
```

```sqf
// description.ext
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

## GRAD_Loadout_fnc_factionGetLoadout
Get loadout classname set via `GRAD_Loadout_fnc_factionSetLoadout`.

Param | Type   | Default Value | Description
------|--------|---------------|--------------------------------------------------------------------------------------------
0     | string | -             | Faction name. Get this with [faction](https://community.bistudio.com/wiki/faction) command.

**Return Value**
String - Loadout classname.

**Example:**
```sqf
// get loadout from above example
private _bluLoadoutClassname = ["BLU_F"] call GRAD_Loadout_fnc_factionGetLoadout;
```

## GRAD_Loadout_fnc_doLoadoutForUnit
Call this with unit as first parameter to dynamically assign loadout during scenario.

Param | Type   | Default Value | Description
------|--------|---------------|------------------------
0     | object | -             | Unit to do loadout for.

**Example:**
```sqf
[player] call GRAD_Loadout_fnc_doLoadoutForUnit;
```

## GRAD_Loadout_fnc_addReviver
Use to dynamically adjust loadout values. This example adds a bit of randomization to Russian helmets and broadcasts the reviver over network (parameter 2, bool):

Param | Type   | Default Value | Description
------|--------|---------------|------------------------------------------------------------------------------------------------------
0     | code   | {}            | Code block that has to return an item classname. Parameters to this are `[previous classname, unit]`.
1     | string | ""            | item option name
2     | bool   | false         | Set to true for global effect (`publicVariable`).

**Example:**
```sqf
[
    {
        params ["_value"];
        if (_value == "rhs_6b27m_digi") then {
            _value = selectRandom ["rhs_6b27m_digi", "rhs_6b27m_digi_bala"];
        };
        _value
    },
    "headgear",
    true
] call GRAD_Loadout_fnc_addReviver;
```

## GRAD_Loadout_fnc_setRandomizationMode
Sets randomization mode of a unit, overriding the [config set value](configuration.md). Effect is global.

Param | Type   | Default Value | Description
------|--------|---------------|-------------------------------------------
0     | object | -             | The unit to set the randomization mode of.
1     | number | 0             | Randomization mode. 0 to disable, 1 to enable, 2 to enable for players only, 3 to enable for AI only.

**Example:**
```sqf
[player, 2] call GRAD_Loadout_fnc_setRandomizationMode;
```

## customGear Functions
There are a number of functions specifically for the `customGear` funcionality. See [customGear](customGear.md#Functions) page for more information.
