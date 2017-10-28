
#define PREFIX grad
#define COMPONENT loadout
#include "\x\cba\addons\main\script_macros_mission.hpp"

private _faction = param [0];

private _path = _faction;
if ([GRAD_Loadout_factionPathMap, _faction] call CBA_fnc_hashHasKey) then {
    _path = [GRAD_Loadout_factionPathMap, _faction] call CBA_fnc_hashGet;
};

_path
