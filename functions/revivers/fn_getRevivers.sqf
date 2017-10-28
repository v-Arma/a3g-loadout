
#define PREFIX grad
#define COMPONENT loadout
#include "\x\cba\addons\main\script_macros_mission.hpp"

private _propertyName = param [0];

private _revivers = GVAR(revivers);
private _pRevivers = [];

if ([_revivers, _propertyName] call CBA_fnc_hashHasKey) then {
	_pRevivers = [_revivers, _propertyName] call CBA_fnc_hashGet;
};

_pRevivers
