
#define PREFIX grad
#define COMPONENT loadout
#include "\x\cba\addons\main\script_macros_mission.hpp"

params ["_loadoutHash", "_unitLoadout"];

if (typeName _loadoutHash != "ARRAY") then {
    throw "loadoutHash is not of type array (and thus, no cba hash) :(("
};
if (typeName _unitLoadout != "ARRAY") then {
    throw "_unitLoadout is not of type array :(("
};

// CBA_fnc_findTypeName ? CBA_fnc_findTypeOf ?

private _getFirstOfType = {
    params ["_array","_classPath"];

    private _className = configName _classPath;
    private _hierarchy = (configHierarchy _classPath);
    _hierarchy call BIS_fnc_ArrayPop;
    private _butLast = _hierarchy call BIS_fnc_ArrayPop;

    _result = "";
    {
        if (_x isKindOf [_className, _butLast]) exitWith {_result = _x; };
    } forEach _array;

    _result
};

private _walkIntoArray = {
    params [["_array",[]],["_indices",[]]];
    {
        _array = _array select _x;
    } forEach _indices;

    _array
};

private _assignFromLoadoutHash = {
    params [["_indices",[]],["_entryName",""],"_classNameToPickOrMapper"];

    if ( [_loadoutHash, _entryName] call CBA_fnc_hashHasKey ) then {
        private _value = [_loadoutHash, _entryName] call CBA_fnc_hashGet;
        if (!(isNil "_classNameToPickOrMapper")) then {
            if (typeName _classNameToPickOrMapper == "CONFIG") then {
                _value = [_value, _classNameToPickOrMapper] call _getFirstOfType;
            };
            if (typeName _classNameToPickOrMapper == "CODE") then {
                _value = [_value] call _classNameToPickOrMapper;
            };
        };

        if (!(isNil "_value")) then {
            _index =  _indices call BIS_fnc_arrayPop;
            _targetArray = [_unitLoadout, _indices] call _walkIntoArray;
            _targetArray set [_index, _value];
        };
    };
};

private _assignValue = {
    params [["_indices",[]], "_value"];

    if (!(isNil "_value")) then {
        _index =  _indices call BIS_fnc_arrayPop;
        _targetArray = [_unitLoadout, _indices] call _walkIntoArray;
        _targetArray set [_index, _value];
    };
};

private _setEmptyParentArrayIfEmptyString = {
    private _indices = _this;
    if (count _indices < 2) then {
        throw '_setEmptyParentArrayIfEmptyString needs two indices at least';
    };
    _testValue = [_unitLoadout, _indices] call _walkIntoArray;
    if (_testValue == "") then {
        _indices call BIS_fnc_arrayPop;
        _targetIdx = _indices call BIS_fnc_arrayPop;
        _targetArray = [_unitLoadout, _indices] call _walkIntoArray;
        _targetArray set [_targetIdx, []];
    };
};

private _normalizeWeaponArray = {
    private _weaponArray = _this;
    if ((count _weaponArray) > 0) then {
        _weaponValue = _weaponArray select 0;
        if ((isNil "_weaponValue") || (_weaponValue == "")) then {
            _weaponArray resize 0;
        } else {
            _weaponArray resize 7;
            {
                private _defaultValue = "";
                if (_forEachIndex >= 4 && _forEachIndex <= 5) then {
                    _defaultValue = [];
                };
                if (isNil "_x") then {
                    _weaponArray set [_forEachIndex, _defaultValue];
                } else {
                    if (_forEachIndex >= 4 && _forEachIndex <= 5) then {
                        if (typeName _x == "STRING") then {
                            if (count _x > 0) then {
                                _weaponArray set [_forEachIndex, [_x, 1]];
                            } else {
                                _weaponArray set [_forEachIndex, _defaultValue];
                            };
                        };
                        // doesnt work for UGL values. no idea where to get those, btw
                        // if (!([_weaponValue, _x select 0] call FUNC(WeaponIsCompatibleMagazine))) then {
                        //    _weaponArray set [_forEachIndex, _defaultValue];
                        //};


                    };
                };
            } forEach _weaponArray;
        };
    };
   _weaponArray
};

private _defaultValueForItemCarriers = {
    private _targetArray = _unitLoadout select _this;
    private _carrierClassName = _targetArray select 0;
    if (!(isNil "_carrierClassName")) then {
        _val = _targetArray select 1;
        if (isNil "_val") then {
            _targetArray set [1, []];
        };
    };
};

[[0, 0], "primaryWeapon"] call _assignFromLoadoutHash;
[[0, 1], "primaryWeaponMuzzle"] call _assignFromLoadoutHash;
[[0, 2], "primaryWeaponPointer"] call _assignFromLoadoutHash;
[[0, 3], "primaryWeaponOptics"] call _assignFromLoadoutHash;
[[0, 4], "primaryWeaponMagazine"] call _assignFromLoadoutHash;
[[0, 5], "primaryWeaponUnderbarrelMagazine"] call _assignFromLoadoutHash;
[[0, 6], "primaryWeaponUnderbarrel"] call _assignFromLoadoutHash;
(_unitLoadout select 0) call _normalizeWeaponArray;

// launcherShit
[[1, 0], "secondaryWeapon"] call _assignFromLoadoutHash;
[[1, 1], "secondaryWeaponMuzzle"] call _assignFromLoadoutHash;
[[1, 2], "secondaryWeaponPointer"] call _assignFromLoadoutHash;
[[1, 3], "secondaryWeaponOptics"] call _assignFromLoadoutHash;
[[1, 4], "secondaryWeaponMagazine"] call _assignFromLoadoutHash;
[[1, 5], "secondaryWeaponUnderbarrelMagazine"] call _assignFromLoadoutHash;
[[1, 6], "secondaryWeaponUnderbarrel"] call _assignFromLoadoutHash;
(_unitLoadout select 1) call _normalizeWeaponArray;

// handgun
[[2, 0], "handgunWeapon"] call _assignFromLoadoutHash;
[[2, 1], "handgunWeaponMuzzle"] call _assignFromLoadoutHash;
[[2, 2], "handgunWeaponPointer"] call _assignFromLoadoutHash;
[[2, 3], "handgunWeaponOptics"] call _assignFromLoadoutHash;
[[2, 4], "handgunWeaponMagazine"] call _assignFromLoadoutHash;
[[2, 5], "handgunWeaponUnderbarrelMagazine"] call _assignFromLoadoutHash;
[[2, 6], "handgunWeaponUnderbarrel"] call _assignFromLoadoutHash;
(_unitLoadout select 2) call _normalizeWeaponArray;

[[3, 0], "uniform"] call _assignFromLoadoutHash;
[[3, 1], "addItemsToUniform", FUNC(normalizeContent)] call _assignFromLoadoutHash;
3 call _defaultValueForItemCarriers;
[3, 0] call _setEmptyParentArrayIfEmptyString;

[[4, 0], "vest"] call _assignFromLoadoutHash;
[[4, 1], "addItemsToVest", FUNC(normalizeContent)] call _assignFromLoadoutHash;
4 call _defaultValueForItemCarriers;
[4, 0] call _setEmptyParentArrayIfEmptyString;

[[5, 0], "backpack"] call _assignFromLoadoutHash;
[[5, 1], "addItemsToBackpack", FUNC(normalizeContent)] call _assignFromLoadoutHash;
5 call _defaultValueForItemCarriers;
[5, 0] call _setEmptyParentArrayIfEmptyString;

[[6], "headgear"] call _assignFromLoadoutHash;
[[7], "goggles" ] call _assignFromLoadoutHash;

[[8, 0], "binoculars"] call _assignFromLoadoutHash; // dont be surprised: it's ... the quaternary weapon, so to speak.
(_unitLoadout select 8) call _normalizeWeaponArray;

[[9, 0], "map"] call _assignFromLoadoutHash;
[[9, 1], "gps"] call _assignFromLoadoutHash;
[[9, 2], "radio"] call _assignFromLoadoutHash;
[[9, 3], "compass"] call _assignFromLoadoutHash;
[[9, 4], "watch"] call _assignFromLoadoutHash;
[[9, 5], "nvgoggles"] call _assignFromLoadoutHash;

_unitLoadout
