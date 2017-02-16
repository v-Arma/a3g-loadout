
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

LOG_2("applying loadouts from mission config file to %! units...", count _units);

{
    [_x] call FUNC(doLoadoutForUnit);
} forEach _units;
