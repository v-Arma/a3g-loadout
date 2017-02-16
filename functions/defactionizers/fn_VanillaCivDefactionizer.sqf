#define PREFIX grad
#define COMPONENT loadout
#include "\x\cba\addons\main\script_macros_mission.hpp"

_unit = param [0];

_faction = faction _unit;
_type = typeOf _unit;
_result = "";

if (_faction != "CIV_F") exitWith {""};

_type select [2];
