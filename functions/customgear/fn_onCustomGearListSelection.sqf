#define PREFIX grad
#define COMPONENT loadout
#include "\x\cba\addons\main\script_macros_mission.hpp"

params ["_ctrlListBox", "_curSelIndex"];

private _display = ctrlParent _ctrlListBox;
private _unit = _display getVariable [QGVAR(unit), objNull];
private _unitLoadout = getUnitLoadout _unit;

private _itemClassname = _ctrlListBox lbData _curSelIndex;
private _hashKey = _ctrlListBox getVariable [QGVAR(hashKey), ""];

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
] find _hashKey;

if (_keyID < 0) exitWith {};

private _fnc_set = [
    {(_unitLoadout select 3) set [0, _itemClassname]},
    {(_unitLoadout select 4) set [0, _itemClassname]},
    {(_unitLoadout select 5) set [0, _itemClassname]},
    {(_unitLoadout select 0) set [0, _itemClassname]},
    {(_unitLoadout select 0) set [1, _itemClassname]},
    {(_unitLoadout select 0) set [3, _itemClassname]},
    {(_unitLoadout select 0) set [2, _itemClassname]},
    {(_unitLoadout select 0) set [6, _itemClassname]},
    {(_unitLoadout select 1) set [0, _itemClassname]},
    {(_unitLoadout select 1) set [1, _itemClassname]},
    {(_unitLoadout select 1) set [3, _itemClassname]},
    {(_unitLoadout select 1) set [2, _itemClassname]},
    {(_unitLoadout select 1) set [6, _itemClassname]},
    {(_unitLoadout select 2) set [0, _itemClassname]},
    {(_unitLoadout select 2) set [1, _itemClassname]},
    {(_unitLoadout select 2) set [3, _itemClassname]},
    {(_unitLoadout select 2) set [2, _itemClassname]},
    {(_unitLoadout select 2) set [6, _itemClassname]},
    {_unitLoadout set [6, _itemClassname]},
    {_unitLoadout set [7, _itemClassname]},
    {(_unitLoadout select 9) set [5, _itemClassname]},
    {(_unitLoadout select 8) set [0, _itemClassname]},
    {(_unitLoadout select 9) set [0, _itemClassname]},
    {(_unitLoadout select 9) set [1, _itemClassname]},
    {(_unitLoadout select 9) set [3, _itemClassname]},
    {(_unitLoadout select 9) set [4, _itemClassname]},
    {(_unitLoadout select 9) set [2, _itemClassname]}
] select _keyID;

call _fnc_set;
_unit setUnitLoadout [_unitLoadout, false];
