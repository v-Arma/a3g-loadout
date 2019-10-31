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
    {uniform _unit},
    {vest _unit},
    {backpack _unit},
    {primaryWeapon _unit},
    {(primaryWeaponItems _unit) select 0},
    {(primaryWeaponItems _unit) select 2},
    {(primaryWeaponItems _unit) select 1},
    {(primaryWeaponItems _unit) select 3},
    {secondaryWeapon _unit},
    {(secondaryWeaponItems _unit) select 0},
    {(secondaryWeaponItems _unit) select 2},
    {(secondaryWeaponItems _unit) select 1},
    {(secondaryWeaponItems _unit) select 3},
    {handgunWeapon _unit},
    {(handgunItems _unit) select 0},
    {(handgunItems _unit) select 2},
    {(handgunItems _unit) select 1},
    {(handgunItems _unit) select 3},
    {headgear _unit},
    {goggles _unit},
    {hmd _unit},
    {binocular _unit},
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
