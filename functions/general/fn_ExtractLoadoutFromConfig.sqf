
#define PREFIX grad
#define COMPONENT loadout
#include "\x\cba\addons\main\script_macros_mission.hpp"

params ['_configPath'];

{
    _value = [_configPath >> _x, "array", false] call CBA_fnc_getConfigEntry;
    if (_value isEqualTo false) then {
        _value = [_configPath >> _x, "text", false] call CBA_fnc_getConfigEntry;
    };
    if (!(_value isEqualTo false)) then {
        _msg = format ["Config property '%1' is not supported anymore, was found in %2", _x, _configPath];
        ERROR(_msg);
    };
} forEach [
    "magazines",
    "items",
    "addMagazines",
    "addItems",
    "weapons",
    "linkedItems"
];


_configValues = [] call CBA_fnc_hashCreate;

{
    _value = [_configPath >> _x, "text", false] call  CBA_fnc_getConfigEntry;
    if (!(_value isEqualTo false)) then {
        [_configValues, _x, _value] call CBA_fnc_hashSet;
    };
} forEach [
    "uniform",
    "vest",
    "backpack",
    "primaryWeapon",
    "secondaryWeapon",
    "handgunWeapon",
    "headgear",
    "goggles",
    "nvgoggles",
    "binoculars",
    "map",
    "gps",
    "compass",
    "watch",
    "radio"
];

{
    _value = [_configPath >> _x, "array", false] call  CBA_fnc_getConfigEntry;
    if (!(_value isEqualTo false)) then {
        [_configValues, _x, _value] call CBA_fnc_hashSet;
    };
} forEach [
    "addItemsToUniform",
    "addItemsToVest",
    "addItemsToBackpack",
    "primaryWeaponAttachments",
    "secondaryWeaponAttachments",
    "handgunWeaponAttachments"
];

_configValues
