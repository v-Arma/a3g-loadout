
#define PREFIX grad
#define COMPONENT loadout
#include "\x\cba\addons\main\script_macros_mission.hpp"

_unit = param [0, objNull];

_configPath = missionConfigFile >> "Loadouts";

if (GVAR(Chosen_Prefix) != "") then {
    _configPath = _configPath >> GVAR(Chosen_Prefix);
};

TRACE_1("applying loadout from mission config file %1 to %2 ...", _configPath, _unit);

_loadoutHash = [_unit, _configPath] call FUNC(GetUnitLoadoutFromConfig);
_loadoutHash = [_loadoutHash, _unit] call FUNC(ApplyRevivers);
[_loadoutHash, _unit] call FUNC(doLoadout);
