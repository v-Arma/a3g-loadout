
#define PREFIX grad
#define COMPONENT loadout
#include "\x\cba\addons\main\script_macros_mission.hpp"

_callback = param [0];
_propertyName = param [1];

_revivers = GVAR(revivers);
_pRevivers = [];

if ([_revivers, _propertyName] call CBA_fnc_hashHasKey) then {
	_pRevivers = [_revivers, _propertyName] call CBA_fnc_hashGet;
};

_pRevivers pushBack _callback;

[_revivers, _propertyName, _pRevivers] call CBA_fnc_hashSet;
