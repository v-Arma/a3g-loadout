#include "component.hpp"

params [["_loadoutHash", []], ["_unit", objNull]];

private _savedCustomGearHash = _unit getVariable QGVAR(savedCustomGearHash);

{
    private _value = [_loadoutHash, _x] call CBA_fnc_hashGet;
    if (!isNil "_value" && {_value isEqualType []}) then {
        if (count _value == 0) then {_value = ""} else {
            _value = _value apply {toLower _x};
            if (
                !isNil "_savedCustomGearHash" &&
                {[_savedCustomGearHash, _x] call CBA_fnc_hashHasKey} &&
                {([_savedCustomGearHash, _x] call CBA_fnc_hashGet) in _value}
            ) then {
                _value = [_savedCustomGearHash, _x] call CBA_fnc_hashGet;
            } else {
                _value = selectRandom _value;
            };
        };
        [_loadoutHash, _x, _value] call CBA_fnc_hashSet;
    };
} forEach [
    "uniform",
    "vest",
    "backpack",
    "primaryWeapon",
    "primaryWeaponMagazine",
    "primaryWeaponMuzzle",
    "primaryWeaponOptics",
    "primaryWeaponPointer",
    "primaryWeaponUnderbarrel",
    "primaryWeaponUnderbarrelMagazine",
    "secondaryWeapon",
    "secondaryWeaponMagazine",
    "secondaryWeaponMuzzle",
    "secondaryWeaponOptics",
    "secondaryWeaponPointer",
    "secondaryWeaponUnderbarrel",
    "secondaryWeaponUnderbarrelMagazine",
    "handgunWeapon",
    "handgunWeaponMagazine",
    "handgunWeaponMuzzle",
    "handgunWeaponOptics",
    "handgunWeaponPointer",
    "handgunWeaponUnderbarrel",
    "handgunWeaponUnderbarrelMagazine",
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
