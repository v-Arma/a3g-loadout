#include "component.hpp"

params [["_unit", objNull], ["_hashKey", ""], ["_commitTime", 0.4]];

private _keyID = [
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
] find _hashKey;

if (_keyID < 0) exitWith {};

private _selectionData = [
    ["Pelvis", 0, [0.4,2.4,0.3]],
    ["Spine3", -0.1, [0,1.4,0.1]],
    ["Spine3", 0, [-1,-1.2,0]],
    ["proxy:\A3\Characters_F\Proxies\weapon.001", [-0.1, 0.1] select (GVAR(curSelectedWeaponID) == 0), [[0.8,-0.8,0], [0.8,0.8,0]] select (GVAR(curSelectedWeaponID) == 0)],
    ["proxy:\A3\Characters_F\Proxies\launcher.001", 0, [[-1.7,-0.1,0], [0.8,0.8,0]] select (GVAR(curSelectedWeaponID) == 1)],
    ["proxy:\A3\Characters_F\Proxies\pistol.001", 0, [[0.4,2.4,0.3], [0.5,0.5,0]] select (GVAR(curSelectedWeaponID) == 2)],
    ["Head_axis", 0, [-0.7,0.7,0]],
    ["Head_axis", 0, [-0.7,0.7,0]],
    ["Head_axis", 0, [-0.7,0.7,0]],
    ["Pelvis", 0, [0.4,2.4,0.3]],
    ["Pelvis", 0, [0.4,2.4,0.3]],
    ["Pelvis", 0, [0.4,2.4,0.3]],
    ["Pelvis", 0, [0.4,2.4,0.3]],
    ["Pelvis", 0, [0.4,2.4,0.3]],
    ["Pelvis", 0, [0.4,2.4,0.3]]
] select _keyID;

_selectionData params ["_selectionName", "_selectionOffsetZ", "_selectionRelPos"];
private _selectionPosition = (_unit selectionPosition _selectionName) vectorAdd [0, 0, _selectionOffsetZ];

private _camTarget = _unit modelToWorldVisual _selectionPosition;
GVAR(customGearCam) camSetTarget _camTarget;
GVAR(customGearCam) camSetPos (_camTarget vectorAdd ([_selectionRelPos, getDir _unit, 2] call BIS_fnc_rotateVector3D));
GVAR(customGearCam) camCommit _commitTime;
