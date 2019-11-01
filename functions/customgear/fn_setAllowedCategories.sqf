#define PREFIX grad
#define COMPONENT loadout
#include "\x\cba\addons\main\script_macros_mission.hpp"

params [["_unit", objNull], ["_allowedCategories", []]];

_unit setVariable [QGVAR(customGearAllowedCategories), _allowedCategories, true];
