
#define PREFIX grad
#define COMPONENT loadout
#include "\x\cba\addons\main\script_macros_mission.hpp"

params [["_loadoutHash", []], ["_unit", objNull]];

[
    _loadoutHash,
    {
        _oldValue = _value;
        _revivers = [_key] call FUNC(GetRevivers);
        {
            _value = [_value, _unit] call _x;
        } forEach _revivers;

        TRACE_2("revivers: replaced %1 with %2", _oldValue, _value);

        [_loadoutHash, _key, _value] call CBA_fnc_hashSet;
    }
] call CBA_fnc_hashEachPair;

_loadoutHash
