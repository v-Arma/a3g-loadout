params  ["_loadoutHash", "_unitLoadout"];

if (typeName _loadoutHash != "ARRAY") then {
    throw "loadoutHash is not of type array (and thus, no cba hash) :(("
};
if (typeName _unitLoadout != "ARRAY") then {
    throw "_unitLoadout is not of type array :(("
};

_assign = {
    params ["_entryName", "_assignFunction"];
    if ( [_loadoutHash, _entryName] call CBA_fnc_hashHasKey ) then {
        _xxx = [_loadoutHash, _entryName] call CBA_fnc_hashGet;
        [_xxx, _loadoutTarget] call _assignFunction;
    };
};

_getFirstOfType = {
    params ["_array", "_classPath"];

    _className = configName _classPath;
    _hierarchy = (configHierarchy _classPath);
    _hierarchy call BIS_fnc_ArrayPop;
    _butLast = _hierarchy call BIS_fnc_ArrayPop;

    _result = "";
    {
        if (_x isKindof [_className, _butLast]) exitWith {_result = _x};
    } forEach _array;

    _result
};

_walkIntoArray = {
    params ["_array", "_indices"];
    {
        _array = _array select _x;
    } forEach _indices;

    _array
};

_assignFromLoadoutHash = {
    params ["_indices", "_entryName", "_classNameToPickOrMapper"];

    if ( [_loadoutHash, _entryName] call CBA_fnc_hashHasKey ) then {
        _value = [_loadoutHash, _entryName] call CBA_fnc_hashGet;
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

_assignValue = {
    params ["_indices", "_value"];
    if (!(isNil "_value")) then {
        _index =  _indices call BIS_fnc_arrayPop;
        _targetArray = [_unitLoadout, _indices] call _walkIntoArray;
        _targetArray set [_index, _value];
    };
};

_setEmptyParentArrayIfEmptyString = {
    _indices = _this;
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

_defaultValueForItemCarriers = {
    _targetArray = _unitLoadout select _this;
    _carrierClassName = _targetArray select 0;
    if (!(isNil "_carrierClassName")) then {
        _val = _targetArray select 1;
        if (isNil "_val") then {
            _targetArray set [1, []];
        };
    };
};

[[0, 0], "primaryWeapon"] call _assignFromLoadoutHash;
[[0, 1], "primaryWeaponAttachments", configfile >> "CfgWeapons" >> "muzzle_snds_H"] call _assignFromLoadoutHash;
[[0, 2], "primaryWeaponAttachments", configfile >> "CfgWeapons" >> "acc_flashlight"] call _assignFromLoadoutHash;
[[0, 3], "primaryWeaponAttachments", configfile >> "CfgWeapons" >> "acc_pointer_IR"] call _assignFromLoadoutHash;
if (!isNil((_unitLoadout select 0) select 0)) then { // else we'd implicitly set NULL for indices 0..3 // FIXME set empty strings
    (_unitLoadout select 0) set [4, []]; // currentMagazine
    (_unitLoadout select 0) set [5, []]; // currentGLMagazine
};
[[0, 6], "primaryWeaponAttachments", configfile >> "CfgWeapons" >> "bipod_01_F_snd"] call _assignFromLoadoutHash;

// launcherShit
[[1, 0], "secondaryWeapon"] call _assignFromLoadoutHash;
[[1, 1], "secondaryWeaponAttachments", configfile >> "CfgWeapons" >> "muzzle_snds_H"] call _assignFromLoadoutHash;
[[1, 2], "secondaryWeaponAttachments", configfile >> "CfgWeapons" >>  "acc_flashlight"] call _assignFromLoadoutHash;
[[1, 3], "secondaryWeaponAttachments", configfile >> "CfgWeapons" >> "acc_pointer_IR"] call _assignFromLoadoutHash;
if (!isNil((_unitLoadout select 1) select 0)) then { // else we'd implicitly set NULL for indices 0..3 // FIXME set empty strings
    (_unitLoadout select 1) set [4, []]; // currentMagazine
    (_unitLoadout select 1) set [5, []]; // currentGLMagazine
};
[[1, 6], "secondaryWeaponAttachments", "bipod_01_F_snd"] call _assignFromLoadoutHash;

// handgun
[[2, 0], "handgunWeapon"] call _assignFromLoadoutHash;
[[2, 1], "handgunWeaponAttachments", configfile >> "CfgWeapons" >> "muzzle_snds_H"] call _assignFromLoadoutHash;
[[2, 2], "handgunWeaponAttachments", configfile >> "CfgWeapons" >> "acc_flashlight"] call _assignFromLoadoutHash;
[[2, 3], "handgunWeaponAttachments", configfile >> "CfgWeapons" >> "acc_pointer_IR"] call _assignFromLoadoutHash;
if (!isNil((_unitLoadout select 2) select 0)) then { // else we'd implicitly set NULL for indices 0..3 // FIXME set empty strings
    (_unitLoadout select 2) set [4, []]; // currentMagazine
    (_unitLoadout select 2) set [5, []]; // currentGLMagazine
};
[[2, 6], "handgunWeaponAttachments", configfile >> "CfgWeapons" >> "bipod_01_F_snd"] call _assignFromLoadoutHash;

[[3, 0], "uniform"] call _assignFromLoadoutHash;
[[3, 1], "addItemsToUniform", A3G_Loadout_fnc_NormalizeMagazinesInContent] call _assignFromLoadoutHash;
3 call _defaultValueForItemCarriers;
[3, 0] call _setEmptyParentArrayIfEmptyString;

[[4, 0], "vest"] call _assignFromLoadoutHash;
[[4, 1], "addItemsToVest", A3G_Loadout_fnc_NormalizeMagazinesInContent] call _assignFromLoadoutHash;
4 call _defaultValueForItemCarriers;
[4, 0] call _setEmptyParentArrayIfEmptyString;

[[5, 0], "backpack"] call _assignFromLoadoutHash;
[[5, 1], "addItemsToBackpack", A3G_Loadout_fnc_NormalizeMagazinesInContent] call _assignFromLoadoutHash;
5 call _defaultValueForItemCarriers;
[5, 0] call _setEmptyParentArrayIfEmptyString;

[[6], "headgear"] call _assignFromLoadoutHash;
[[7], "goggles" ] call _assignFromLoadoutHash;

[[8, 0], "binoculars"] call _assignFromLoadoutHash; // dont be surprised: it's ... the quaternary weapon, so to speak.
[8, 0] call _setEmptyParentArrayIfEmptyString;

[[9, 0], "map"] call _assignFromLoadoutHash;
[[9, 1], "gps"] call _assignFromLoadoutHash;
[[9, 2], "radio"] call _assignFromLoadoutHash;
[[9, 3], "compass"] call _assignFromLoadoutHash;
[[9, 4], "watch"] call _assignFromLoadoutHash;
[[9, 5], "nvgoggles"] call _assignFromLoadoutHash;

_unitLoadout
