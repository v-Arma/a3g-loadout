
#define PREFIX grad
#define COMPONENT loadout
#include "\x\cba\addons\main\script_macros_mission.hpp"

private ["_configPath", "_isMissionStart", "_sidePath", "_getSidePath", "_rolePath", "_namePath", "_typePath"];
params [["_mode", ""]];

_configPath = missionConfigFile >> "Loadouts";

if (GRAD_Loadout_Chosen_Prefix != "") then {
    _configPath = _configPath >> GRAD_Loadout_Chosen_Prefix;
};

_isMissionStart = if (typeName _mode == "STRING") then {if (_mode == "postInit") then {true} else {false}} else {false};
_units = ([_isMissionStart] call GRAD_Loadout_fnc_GetApplicableUnits);

LOG_2("applying loadouts from mission config file path '%1' to %2 units...", _configPath, count _units);
systemChat _msg;

{
    _loadoutHash = [_x, _configPath] call GRAD_Loadout_fnc_GetUnitLoadoutFromConfig;
    [_loadoutHash, _x] call GRAD_Loadout_fnc_doLoadout;
} forEach _units;
