#define PREFIX grad
#define COMPONENT loadout
#include "\x\cba\addons\main\script_macros_mission.hpp"

params [["_unit", objNull],["_loadoutHash", []], ["_ignoreCurrentLoadout", false]];

private _loadoutOptionsHash = [[], false] call CBA_fnc_hashCreate;
private _currentLoadout = getUnitLoadout _unit;
private _allowedCategories = _unit getVariable [QGVAR(customGearAllowedCategories), GVAR(customGearAllowedCategories)];

{
    private _key = _x;
    private _value = [_loadoutHash, _key] call CBA_fnc_hashGet;
    if (_value isEqualType []) then {_value = _value apply {toLower _x}};

    if (
        _value isEqualType [] &&
        {count _value > 0} &&
        {
            _ignoreCurrentLoadout ||
            ((toLower ([_unit, _key] call FUNC(getCurrentItem))) in _value) ||
            ((toLower ([_unit, _key, true] call FUNC(getCurrentItem))) in _value)
        }
    ) then {
        [_loadoutOptionsHash, _key, _value] call CBA_fnc_hashSet;
    };
} forEach ([
    "uniform",
    "vest",
    "backpack",
    "primaryWeapon",
    "primaryWeaponMuzzle",
    "primaryWeaponOptics",
    "primaryWeaponPointer",
    "primaryWeaponUnderbarrel",
    "secondaryWeapon",
    "secondaryWeaponMuzzle",
    "secondaryWeaponOptics",
    "secondaryWeaponPointer",
    "secondaryWeaponUnderbarrel",
    "handgunWeapon",
    "handgunWeaponMuzzle",
    "handgunWeaponOptics",
    "handgunWeaponPointer",
    "handgunWeaponUnderbarrel",
    "headgear",
    "goggles",
    "nvgoggles",
    "binoculars",
    "map",
    "gps",
    "compass",
    "watch",
    "radio"
] arrayIntersect _allowedCategories);

_loadoutOptionsHash
