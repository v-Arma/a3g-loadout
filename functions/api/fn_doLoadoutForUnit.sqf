#include "component.hpp"

params [["_unit", objNull]];

private _configPath = missionConfigFile >> "Loadouts";

if (GVAR(Chosen_Prefix) != "") then {
    _configPath = _configPath >> GVAR(Chosen_Prefix);
};

TRACE_1("applying loadout from mission config file %1 to %2 ...", _configPath, _unit);

private _loadoutHash = [_unit, _configPath] call FUNC(GetUnitLoadoutFromConfig);
[_loadoutHash, _unit] call FUNC(randomizeLoadout);
_loadoutHash = [_loadoutHash, _unit] call FUNC(ApplyRevivers);

if (([_loadoutHash] call CBA_fnc_hashSize) > 0) then {
    [_loadoutHash, _unit] call FUNC(DoLoadout);
} else {
    TRACE_1("no loadout entries found for %1, skipping unit", _unit);
};
