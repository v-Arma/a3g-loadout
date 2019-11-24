# Variables


## GRAD_Loadout_Chosen_Prefix
You can define a global variable called `GRAD_Loadout_Chosen_Prefix` – this will lead to GRAD Loadout reading from a *subclass* of `Loadouts`.

**Example:**
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

## GRAD_Loadout_lastLoadoutApplicationTime
This is a unit-specific variable that saves the time the last loadout was applied (derived from `CBA_missionTime`). This variable is public.

**Example:**
```sqf
private _lastApplication = player getVariable "GRAD_Loadout_lastLoadoutApplicationTime";
hint format ["Player loadout was applied %1s ago.", round (CBA_missionTime - _lastApplication)];
```

## GRAD_Loadout_applicationCount
This is a unit-specific variable that saves how many times a loadout has been applied to the unit. This variable is public.

**Example:**
```sqf
private _applicationCount = player getVariable ["GRAD_Loadout_applicationCount",0];
hint format ["Player loadout was applied %1 times.", _applicationCount];
```
