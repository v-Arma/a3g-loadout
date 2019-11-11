// GRAD_Loadout_usedConfigs

#include "component.hpp"

// get all config Classes within Loadouts, array diff with GRAD_Loadout_usedConfigs

private _configPath = [] call FUNC(GetLoadoutConfigPath);
private _maxConfigDepth = 10; // err on high side :P

private _allLoadoutClasses = ([_configPath, _maxConfigDepth, true] call BIS_fnc_returnChildren);

private _unusedClasses = _allLoadoutClasses - GVAR(usedConfigs);

private _unusedClassesAsStrings = [];
{
    _unusedClassesAsStrings pushBack [_x, "STRING"] call BIS_fnc_configPath;
} forEach _unusedClasses;

private _unusedClassesWithoutParents = [];
{
    private _potentialParentClass = _x;
    private _hasBeenFound = false;
    {
        if ((_x find _potentialParentClass) == 0) exitWith { _hasBeenFound = true; };
    } forEach _unusedClassesAsStrings;
    if (!_hasBeenFound) then {
        _unusedClassesWithoutParents pushBack _potentialParentClass;
    };
} forEach _unusedClassesAsStrings;

_unusedClassesWithoutParents;
