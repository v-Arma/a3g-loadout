
#define PREFIX grad
#define COMPONENT loadout
#include "\x\cba\addons\main\script_macros_mission.hpp"

private _unit = param [0];

private _defactionedClassname = "";
{
    _defactionedClassname = [_unit] call _x;
    if (_defactionedClassname != "") exitWith {true};
} forEach [FUNC(VanillaMilitaryDefactionizer), FUNC(VanillaCivDefactionizer)];

if (_defactionedClassname == "") then {
    WARNING_1("type name of unit %1 cannot be defactionized :(", _unit);
};

TRACE_2("unit class %1 defactionized to %2", typeOf _unit, _defactionedClassname);

_defactionedClassname
