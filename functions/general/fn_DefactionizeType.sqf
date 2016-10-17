
#define PREFIX grad
#define COMPONENT loadout
#include "\x\cba\addons\main\script_macros_mission.hpp"

_unit = param [0];

_faction = faction _unit;
_type = typeOf _unit;
_result = "";

_getTypePrefix = {
    _faction = param [0];

    _prefix =  _faction select [0, (count _faction) - 1]; // cut suffix F
    _initial = _prefix select [0, 1];

    (_initial + (_prefix select [3])); // cut middle part & return
};

_typePrefix = [_faction] call _getTypePrefix;

_idx = _type find _typePrefix;
if (_idx != 0) then {
    WARNING_1("type name of unit %1 cannot be defactionized :(", _unit);
} else {
    _result = _type select [count _typePrefix];
};

_result
