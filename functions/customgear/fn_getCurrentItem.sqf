params [["_unit", objNull], ["_key", ""], ["_getBaseWeapon", false]];

private _keyID = [
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
] find _key;

private _currentItem = "";
if (_keyID < 0) exitWith {_currentItem};

private _fnc_getCurrent = [
    {((getUnitLoadout _unit) param [3, []]) param [0, ""]},
    {((getUnitLoadout _unit) param [4, []]) param [0, ""]},
    {((getUnitLoadout _unit) param [5, []]) param [0, ""]},
    {((getUnitLoadout _unit) param [0, []]) param [0, ""]},
    {((getUnitLoadout _unit) param [0, []]) param [1, ""]},
    {((getUnitLoadout _unit) param [0, []]) param [3, ""]},
    {((getUnitLoadout _unit) param [0, []]) param [2, ""]},
    {((getUnitLoadout _unit) param [0, []]) param [6, ""]},
    {((getUnitLoadout _unit) param [1, []]) param [0, ""]},
    {((getUnitLoadout _unit) param [1, []]) param [1, ""]},
    {((getUnitLoadout _unit) param [1, []]) param [3, ""]},
    {((getUnitLoadout _unit) param [1, []]) param [2, ""]},
    {((getUnitLoadout _unit) param [1, []]) param [6, ""]},
    {((getUnitLoadout _unit) param [2, []]) param [0, ""]},
    {((getUnitLoadout _unit) param [2, []]) param [1, ""]},
    {((getUnitLoadout _unit) param [2, []]) param [3, ""]},
    {((getUnitLoadout _unit) param [2, []]) param [2, ""]},
    {((getUnitLoadout _unit) param [2, []]) param [6, ""]},
    {(getUnitLoadout _unit) param [6, ""]},
    {(getUnitLoadout _unit) param [7, ""]},
    {((getUnitLoadout _unit) param [9, []]) param [5, ""]},
    {((getUnitLoadout _unit) param [8, []]) param [0, ""]},
    {((getUnitLoadout _unit) param [9, []]) param [0, ""]},
    {((getUnitLoadout _unit) param [9, []]) param [1, ""]},
    {((getUnitLoadout _unit) param [9, []]) param [3, ""]},
    {((getUnitLoadout _unit) param [9, []]) param [4, ""]},
    {((getUnitLoadout _unit) param [9, []]) param [2, ""]}
] select _keyID;

private _current = call _fnc_getCurrent;

if (_getBaseWeapon) then {
    _current = [configfile >> "CfgWeapons" >> _current, "baseWeapon", _current] call BIS_fnc_returnConfigEntry;
};

_current
