#include "component.hpp"

params ["_unit"];

private _defactionedClassname = "";
{
    _defactionedClassname = [_unit] call _x;
    if (_defactionedClassname != "") exitWith {true};
} forEach [FUNC(VanillaMilitaryDefactionizer), FUNC(VanillaCivDefactionizer)];

if (_defactionedClassname == "") then {
    WARNING_1("type name of unit %1 cannot be defactionized :( defaulting to classname", _unit);
    _defactionedClassname = typeOf _unit;
};

TRACE_2("unit class %1 defactionized to %2", typeOf _unit, _defactionedClassname);

_defactionedClassname
