
#define PREFIX grad
#define COMPONENT loadout
#include "\x\cba\addons\main\script_macros_mission.hpp"

params [["_faction",""]];

// return faction as path if no value exists
GVAR(factionPathMap) getVariable [_faction,_faction]
