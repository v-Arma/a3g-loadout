// GRAD_Loadout_usedConfigs

#define PREFIX grad
#define COMPONENT loadout
#include "\x\cba\addons\main\script_macros_mission.hpp"


// get all config Classes within Loadouts, array diff with GRAD_Loadout_usedConfigs

_configPath = [] call FUNC(getLoadoutConfigPath);
_maxConfigDepth = 10; // err on high side :P

_allLoadoutClasses = ([_configPath, _maxConfigDepth, true] call BIS_fnc_returnChildren);

_unusedClasses = _allLoadoutClasses - GRAD_Loadout_usedConfigs;

_unusedClassesAsStrings = [];
{
    _unusedClassesAsStrings pushBack [_x, "STRING"] call BIS_fnc_configPath;
} forEach _unusedClasses;

_unusedClassesWithoutParents = [];
{
    _potentialParentClass = _x;
    _hasBeenFound = false;
    {
        if ((_x find _potentialParentClass) == 0) exitWith { _hasBeenFound = true; };
    } forEach _unusedClassesAsStrings;
    if (!_hasBeenFound) then {
        _unusedClassesWithoutParents pushBack _potentialParentClass;
    };
} forEach _unusedClassesAsStrings;

_unusedClassesWithoutParents;
