params ['_configPath'];

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
    "linkedItems",
    "items",
    "magazines",
    "addItemsToUniform",
    "addItemsToVest",
    "addItemsToBackpack",
    "addItems",
    "addMagazines",
    "weapons",
    "primaryWeaponAttachments",
    "secondaryWeaponAttachments",
    "handgunWeaponAttachments"
];

_configValues
