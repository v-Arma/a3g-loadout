#include "component.hpp"

params [["_loadoutHash", []], ["_unit", objNull]];

private _savedCustomGearHash = _unit getVariable QGVAR(savedCustomGearHash);

private _randomizationModeConfig = if (isNil QGVAR(randomizationModeConfig)) then {
    [(missionConfigFile >> "Loadouts"), "randomizationMode", 1] call BIS_fnc_returnConfigEntry;
} else {
    GVAR(randomizationModeConfig)
};
private _randomizationMode = _unit getVariable QGVAR(randomizationMode);
if (isNil "_randomizationMode") then {
    _randomizationMode = _randomizationModeConfig;
};
private _randomizationEnabledForUnit = switch (true) do {
    case (_randomizationMode == 0): {false};
    case (_randomizationMode == 1): {true};
    case (_randomizationMode == 2 && isPlayer _unit): {true};
    case (_randomizationMode == 3 && !isPlayer _unit): {true};
    default {false};
};

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
                if (_randomizationEnabledForUnit) then {
                    _value = selectRandom _value;
                } else {
                    _value = _value param [0, ""];
                };
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
