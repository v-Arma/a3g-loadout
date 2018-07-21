#define PREFIX grad
#define COMPONENT loadout
#include "\x\cba\addons\main\script_macros_mission.hpp"



// SUBFUNCTIONS ================================================================
private _fnc_verify = {
    params ["_loadoutHash","_unit"];

    _this call _fnc_checkContainers;
    _this call _fnc_checkWeapons;
    _this call _fnc_checkOther;
};

private _fnc_getMass = {
    params ["_className"];
    private _mass = [configFile >> "CfgWeapons" >> _className >> "ItemInfo","mass",0] call BIS_fnc_returnConfigEntry;
    if (_mass == 0) then {
        _mass = [configFile >> "CfgWeapons" >> _className >> "WeaponSlotsInfo","mass",0] call BIS_fnc_returnConfigEntry;
    };
    if (_mass == 0) then {
        _mass = [configFile >> "CfgMagazines" >> _className,"mass",0] call BIS_fnc_returnConfigEntry;
    };
    if (_mass == 0) then {
        _mass = [configFile >> "CfgVehicles" >> _className,"mass",0] call BIS_fnc_returnConfigEntry;
    };
    _mass
};

private _fnc_getLoad = {
    params ["_container","_itemsList"];
    _load = 0;
    {
        _load = _load + ([_x] call _fnc_getMass);
        false
    } count _itemsList;
    _load/(getContainerMaxLoad _container)
};

private _fnc_checkClassExists = {
    params ["_className",["_allowedConfigs",["cfgVehicles","cfgWeapons","cfgMagazines","cfgGlasses"]]];

    _classExists = false;
    {
        if (isClass (configFile >> _x >> _className)) exitWith {_classExists = true};
    } forEach _allowedConfigs;
    _classExists
};

private _fnc_getRoleDescription = {
    params ["_unit"];
    _roleDescription = roleDescription _unit;
    if (_roleDescription == "") then {
        _roleDescription = [configfile >> "CfgVehicles" >> typeOf _unit,"displayName",""] call BIS_fnc_returnConfigEntry;
    };
    _roleDescription
};

private _fnc_checkContainers = {
    params ["_loadoutHash","_unit"];
    {
        _x params ["_containerKey","_itemsKey"];
        _container = [_loadoutHash,_containerKey] call CBA_fnc_hashGet;
        _itemsList = [_loadoutHash,_itemsKey] call CBA_fnc_hashGet;

        if (!isNil "_itemsList" && (isNil "_container" || {_container == ""}) && {count _itemsList > 0}) then {
            _errorLog pushBack [format ["no %1 for %2",_containerKey,_itemsKey],_unit];
        };

        if (!isNil "_container" && {_container != ""}) then {
            _containerExists = [_container,["cfgVehicles","cfgWeapons"]] call _fnc_checkClassExists;
            if (!_containerExists) then {
                _errorLog pushBack [format ["%1 %2 does not exist",_containerKey,_container],_unit];
            };
        };

        if (!isNil "_itemsList" && !isNil "_container" && {count _itemsList > 0} && {_container != ""}) then {
            if (count _itemsList == 0) then {
                _warningLog pushBack [format ["no items in %1",_containerKey],_unit];
            };
            _load = [_container,_itemsList] call _fnc_getLoad;
            if (_load > 1) then {
                _errorLog pushBack [format ["%1 %2 loaded beyond capacity (%3%4)",_containerKey,_container,round (_load*100),"%"],_unit];
            };
        };

    } forEach [
        ["uniform","addItemsToUniform"],
        ["vest","addItemsToVest"],
        ["backpack","addItemsToBackpack"]
    ];
};

private _fnc_checkWeapons = {
    params ["_loadoutHash","_unit"];

    {
        _x params ["_weaponKey","_weaponAccessoryKeys","_magazineKeys"];
        _weaponClassname = [_loadoutHash,_weaponKey] call CBA_fnc_hashGet;
        if (!isNil "_weaponClassname" && {_weaponClassname != ""}) then {
            if !([_weaponClassname,["cfgWeapons"]] call _fnc_checkClassExists) then {
                _errorLog pushBack [format ["%1 %2 does not exist",_x,_weaponClassname]];
            } else {
                {
                    _accessoryClassname = [_loadoutHash,_x] call CBA_fnc_hashGet;
                    if (!isNil "_accessoryClassname" && {_accessoryClassname != ""}) then {
                        if !([_weaponClassname,_accessoryClassname,_forEachIndex] call _fnc_checkAccessoryFits) then {
                            _errorLog pushBack [format ["%1 %2 is not compatible with weapon %3",_x,_accessoryClassname,_weaponClassname],_unit];
                        };
                    };
                } forEach _weaponAccessoryKeys;

                {
                    _magazineClassname = [_loadoutHash,_x] call CBA_fnc_hashGet;
                    if (!isNil "_magazineClassname" && {_magazineClassname != ""}) then {
                        if !([_weaponClassname,_magazineClassname,_forEachIndex] call _fnc_magazineFits) then {
                            _errorLog pushBack [format ["%1 %2 is not compatible with weapon %3",_x,_magazineClassname,_weaponClassname],_unit];
                        };
                    };
                } forEach _magazineKeys;
            };
        };
    } forEach [
        ["primaryWeapon",["primaryWeaponMuzzle","primaryWeaponPointer","primaryWeaponOptics","primaryWeaponUnderbarrel"],["primaryWeaponMagazine","primaryWeaponUnderbarrelMagazine"]],
        ["secondaryWeapon",["secondaryWeaponMuzzle","secondaryWeaponPointer","secondaryWeaponOptics","secondaryWeaponUnderbarrel"],["secondaryWeaponMagazine","secondaryWeaponUnderbarrelMagazine"]],
        ["handgunWeapon",["handgunWeaponMuzzle","handgunWeaponPointer","handgunWeaponOptics","handgunWeaponUnderbarrel"],["handgunWeaponMagazine","handungWeaponUnderbarrelMagazine"]]
    ];
};

private _fnc_checkAccessoryFits = {
    params ["_weaponClassname","_accessoryClassname","_accessoryTypeID"];
    _accessorySlots = [["MuzzleSlot"],["PointerSlot"],["CowsSlot"],["UnderBarrelSlot","GripodSlot"]] select _accessoryTypeID;

    _accessoryFits = false;
    {
        // check if class exists first, because Arma throws some bullshit error message when nonexistant class is accessed
        private _configPath = (configFile >> "CfgWeapons" >> _weaponClassname >> "WeaponSlotsInfo" >> _x);
        if (isClass _configPath) then {
            if (([_configPath >> "compatibleItems",_accessoryClassname,0] call BIS_fnc_returnConfigEntry) == 1) exitWith {
                _accessoryFits = true;
            };
        };
    } forEach _accessorySlots;
    _accessoryFits
};

private _fnc_magazineFits = {
    params ["_weaponClassname","_magazineClassname","_magazineTypeID"];

    _magazineFits = false;
    if (_magazineTypeID == 0) then {
        _magazineFits = _magazineClassname in ([configfile >> "CfgWeapons" >> _weaponClassname,"magazines",[]] call BIS_fnc_returnConfigEntry);
    };
    if (_magazineTypeID == 1) then {
        _muzzles = [configfile >> "CfgWeapons" >> _weaponClassname,"muzzles",[]] call BIS_fnc_returnConfigEntry;
        {
            if (_magazineClassname in ([configfile >> "CfgWeapons" >> _weaponClassname >> _x,"magazines",[]] call BIS_fnc_returnConfigEntry)) exitWith {
                _magazineFits = true;
            };
        } forEach _muzzles;
    };
    _magazineFits
};

private _fnc_checkOther = {
    params ["_loadoutHash","_unit"];

    {
        _otherClassname = [_loadoutHash,_x] call CBA_fnc_hashGet;
        if (!isNil "_otherClassname" && {_otherClassname != ""}) then {
            if !([_otherClassname] call _fnc_checkClassExists) then {
                _errorLog pushBack [format ["%1 %2 does not exist",_x,_otherClassname],_unit];
            };
        };
    } forEach ["headgear","goggles","nvgoggles","binoculars","map","gps","compass","watch","radio"];
};

// MAIN ========================================================================
private _configPath = missionConfigFile >> "Loadouts";

if ((missionNamespace getVariable [QGVAR(Chosen_Prefix),""]) != "") then {
    _configPath = _configPath >> GVAR(Chosen_Prefix);
};

private _errorLog = [];
private _warningLog = [];
private _verifiedLoadoutCount = 0;

{
    _loadoutHash = [_x,_configPath] call FUNC(GetUnitLoadoutFromConfig);
    _loadoutHash = [_loadoutHash,_x] call FUNC(ApplyRevivers);

    if (([_loadoutHash] call CBA_fnc_hashSize) > 0) then {
        [_loadoutHash,_x] call _fnc_verify;
        _verifiedLoadoutCount = _verifiedLoadoutCount + 1;
    };
} forEach allUnits;

diag_log "GRAD-LOADOUT VERIFICATION REPORT =====================================";
diag_log format ["%1 loadouts checked",_verifiedLoadoutCount];
diag_log format ["%1 errors, %2 warnings",count _errorLog,count _warningLog];
{
    _logType = ["ERROR","WARNING"] select _forEachIndex;
    {
        _x params ["_message","_unit"];
        diag_log format ["%1: %2 - %3 (%4)",_logType,_message,_unit,[_unit] call _fnc_getRoleDescription];
    } forEach _x;
} forEach [_errorLog,_warningLog];
diag_log "======================================================================";

systemChat format ["%1 loadouts checked",_verifiedLoadoutCount];
systemChat format ["%1 errors, %2 warnings",count _errorLog,count _warningLog];
if (count _errorLog > 0 || count _warningLog > 0) then {systemChat "see rpt file for results"};
