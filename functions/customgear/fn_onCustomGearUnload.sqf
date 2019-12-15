#include "component.hpp"

params [["_display",displayNull]];

// destroy cam
GVAR(customGearCam) cameraeffect ["terminate", "back"];
camDestroy GVAR(customGearCam);
GVAR(customGearCam) = nil;

// save selected loadout
private _unit = _display getVariable [QGVAR(unit), objNull];
private _loadoutOptionsHash = _display getVariable [QGVAR(loadoutOptionsHash), []];

private _savedCustomGearHash = [[], false] call CBA_fnc_hashCreate;

[_loadoutOptionsHash, {
    private _currentItem = [_unit, _key, true] call FUNC(getCurrentItem);
    if (_currentItem isEqualType "" && {_currentItem != ""}) then {
        [_savedCustomGearHash, _key, toLower _currentItem] call CBA_fnc_hashSet;
    };
}] call CBA_fnc_hashEachPair;

_unit setVariable [QGVAR(savedCustomGearHash), _savedCustomGearHash, false];
