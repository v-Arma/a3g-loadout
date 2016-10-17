
#define PREFIX grad
#define COMPONENT loadout
#include "\x\cba\addons\main\script_macros_mission.hpp"

params ['_configPath'];

GRAD_Loadout_usedConfigs pushBack _configPath;

{
    _value = [_configPath >> _x, "array", false] call CBA_fnc_getConfigEntry;
    if (_value isEqualTo false) then {
        _value = [_configPath >> _x, "text", false] call CBA_fnc_getConfigEntry;
    };
    if (!(_value isEqualTo false)) then {
        // "Unsupported loadout value",  // TODO use the TITLE variant added 2016-10
        ERROR_2("Config property %1 is not supported anymore, was found in %2. Please see README", _x, _configPath);
    };
} forEach [
    "magazines",
    "items",
    "addMagazines",
    "addItems",
    "weapons",
    "linkedItems",
    "primaryWeaponAttachments",
    "secondaryWeaponAttachments",
    "handgunWeaponAttachments"
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
];

{
    _value = [_configPath >> _x, "array", false] call  CBA_fnc_getConfigEntry;
    if (!(_value isEqualTo false)) then {
        [_configValues, _x, _value] call CBA_fnc_hashSet;
    };
} forEach [
    "addItemsToUniform",
    "addItemsToVest",
    "addItemsToBackpack"
];

_configValues
