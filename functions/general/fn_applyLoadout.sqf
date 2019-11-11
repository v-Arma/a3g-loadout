#include "component.hpp"

params [["_mode", ""]];

private _configPath = missionConfigFile >> "Loadouts";

if (GVAR(Chosen_Prefix) != "") then {
    _configPath = _configPath >> GVAR(Chosen_Prefix);
};

private _isMissionStart = if (typeName _mode == "STRING") then {if (_mode == "postInit") then {true} else {false}} else {false};
_units = ([_isMissionStart] call FUNC(GetApplicableUnits));

LOG_2("applying loadouts from mission config file to %! units...", count _units);

{
    [_x] call FUNC(DoLoadoutForUnit);
} forEach _units;
