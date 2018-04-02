
#define PREFIX grad
#define COMPONENT loadout
#include "\x\cba\addons\main\script_macros_mission.hpp"

GVAR(usedConfigs) = [];
GVAR(Chosen_Prefix) = "";

// note: units get property GRAD_Loadout_applicationCount

GVAR(factionPathMap) = [true] call CBA_fnc_createNamespace;
GVAR(revivers) = [true] call CBA_fnc_createNamespace;
