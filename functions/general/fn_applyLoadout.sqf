
#define PREFIX grad
#define COMPONENT loadout
#include "\x\cba\addons\main\script_macros_mission.hpp"

private ["_configPath", "_isMissionStart", "_sidePath", "_getSidePath", "_rolePath", "_namePath", "_typePath"];
params [["_mode", ""]];

_configPath = missionConfigFile >> "Loadouts";

if (GVAR(Chosen_Prefix) != "") then {
    _configPath = _configPath >> GVAR(Chosen_Prefix);
};

_isMissionStart = if (typeName _mode == "STRING") then {if (_mode == "postInit") then {true} else {false}} else {false};
_units = ([_isMissionStart] call FUNC(GetApplicableUnits));

LOG_2("applying loadouts from mission config file path '%1' to %2 units...", _configPath, count _units);

{
    _loadoutHash = [_x, _configPath] call FUNC(GetUnitLoadoutFromConfig);
    _loadoutHash = [_loadoutHash, _x] call FUNC(ApplyRevivers);
    [_loadoutHash, _x] call FUNC(doLoadout);
} forEach _units;
