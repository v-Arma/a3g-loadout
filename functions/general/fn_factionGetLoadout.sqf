params ["_faction"];

_path = _faction;
if ([GRAD_Loadout_factionPathMap, _faction] call CBA_fnc_hashHasKey) then {
    _path = [GRAD_Loadout_factionPathMap, _faction] call CBA_fnc_hashGet;
};

_path
