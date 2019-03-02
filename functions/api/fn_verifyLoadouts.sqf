#define PREFIX grad
#define COMPONENT loadout
#include "\x\cba\addons\main\script_macros_mission.hpp"

#define CENTER(PARENT_SIZE, CHILD_SIZE)     ((PARENT_SIZE / 2) - (CHILD_SIZE / 2))
#define SZ_SCALE                            (safezoneW min safezoneH)
#define X_SCALE                             (SZ_SCALE * 0.75)
#define Y_SCALE                             (SZ_SCALE * 1.0)

#define PADDING_X                           (0.025 * X_SCALE)
#define PADDING_Y                           (0.025 * Y_SCALE)
#define SPACER_Y                            (0.000 * Y_SCALE)

#define TOTAL_W                             (safeZoneW)
#define TOTAL_H                             (safeZoneH)
#define TOTAL_X                             (CENTER(1,TOTAL_W))
#define TOTAL_Y                             (CENTER(1,TOTAL_H))

#define TITLE_H                             (0.025 * Y_SCALE)
#define BACKGROUND_H                        (TOTAL_H - SPACER_Y - TITLE_H)
#define BACKGROUND_Y                        (TOTAL_Y + SPACER_Y + TITLE_H)

#define BACKGROUND_COLOR                    [0.1,0.1,0.1,1]

// SUBFUNCTIONS ================================================================
private _fnc_verify = {
    params ["_loadoutHash","_unit"];

    _this call _fnc_checkContainers;
    _this call _fnc_checkWeapons;
    _this call _fnc_checkOther;
};

private _fnc_getMass = {
    params ["_className"];

    // workaround for weapons with attachments arrays --> handle all classnames as arrays
    if !(_className isEqualType []) then {
        _className = [_className];
    };

    private _mass = 0;
    {
        _thisMass = [configFile >> "CfgWeapons" >> _x >> "ItemInfo","mass",0] call BIS_fnc_returnConfigEntry;
        if (_thisMass isEqualTo 0) then {
            _thisMass = [configFile >> "CfgWeapons" >> _x >> "WeaponSlotsInfo","mass",0] call BIS_fnc_returnConfigEntry;
        };
        if (_thisMass isEqualTo 0) then {
            _thisMass = [configFile >> "CfgMagazines" >> _x,"mass",0] call BIS_fnc_returnConfigEntry;
        };
        if (_thisMass isEqualTo 0) then {
            _thisMass = [configFile >> "CfgVehicles" >> _x,"mass",0] call BIS_fnc_returnConfigEntry;
        };
        if !(_thisMass isEqualType 0) then {
            _thisMass = 0;
        };

        _mass = _mass + _thisMass;
    } forEach _className;

    _mass
};

private _fnc_getLoad = {
    params ["_container","_itemsList"];
    _load = 0;
    {
        _load = _load + ([_x] call _fnc_getMass);
        false
    } count _itemsList;
    _maxLoad = getContainerMaxLoad _container;

    _loadRatio = if (_maxLoad <= 0) then {-1} else {_load/_maxLoad};
    _loadRatio
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
            } else {
                _load = [_container,_itemsList] call _fnc_getLoad;
                if (_load > 1) then {
                    _errorLog pushBack [format ["%1 %2 loaded beyond capacity (%3%4)",_containerKey,_container,round (_load*100),"%"],_unit];
                };
                if (_load < 0) then {
                    _errorLog pushBack [format ["%1 %2 can not hold any items",_containerKey,_container],_unit];
                };
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

    if (_magazineTypeID > 1) exitWith {
        ERROR_1("_magazineTypeID > 1 in _fnc_magazineFits for weapon (%1)",_weaponClassname);
        false
    };

    private _magazineFits = false;

    // main magazine
    if (_magazineTypeID == 0) then {

        private _weaponConfig = configfile >> "CfgWeapons" >> _weaponClassname;
        _magazineFits = _magazineClassname in ([_weaponConfig,"magazines",[]] call BIS_fnc_returnConfigEntry);

        // check magazine wells
        if (!_magazineFits) then {
            _magazineFits = [_magazineClassname,_weaponConfig] call _fnc_magazineFitsMagwell;
        };
    };

    // underbarrel magazine
    if (_magazineTypeID == 1) then {
        _muzzles = [configfile >> "CfgWeapons" >> _weaponClassname,"muzzles",[]] call BIS_fnc_returnConfigEntry;
        {
            private _muzzleConfig = configfile >> "CfgWeapons" >> _weaponClassname >> _x;
            if (_magazineClassname in ([_muzzleConfig,"magazines",[]] call BIS_fnc_returnConfigEntry)) exitWith {
                _magazineFits = true;
            };

            if ([_magazineClassname,_muzzleConfig] call _fnc_magazineFitsMagwell) exitWith {
                _magazineFits = true;
            };
        } forEach _muzzles;
    };

    _magazineFits
};

private _fnc_magazineFitsMagwell = {
        params ["_magazineClassname", "_configPath"];

        private _magazineFitsMagwell = false;

        // magazine well names
        {
            // get all magazines from compatibility sets (e.g."BI_Magazines")
            private _compatibleMagazines = [];
            private _magWellConfigPath = configfile >> "CfgMagazineWells" >> _x;
            {
                _compatibleMagazines append ([_magWellConfigPath,configName _x,[]] call BIS_fnc_returnConfigEntry);
            } forEach (configProperties [_magWellConfigPath]);

            // check if magazine is in compatible magazines
            if (_magazineClassname in _compatibleMagazines) exitWith {_magazineFitsMagwell = true};
        } forEach ([_configPath,"magazineWell",[]] call BIS_fnc_returnConfigEntry);

        _magazineFitsMagwell
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

private _fnc_errorDisplay = {
    params ["_textArray",["_title",""]];

    private _display = (findDisplay 46) createDisplay "RscDisplayEmpty";
    if (isNull _display) exitWith {systemChat "[GRAD] (loadout) ERROR: Display is null."};

    private _titleCtrl = _display ctrlCreate ["RscTitle",-1];
    _titleCtrl ctrlSetPosition [TOTAL_X,TOTAL_Y,TOTAL_W,TITLE_H];
    _titleCtrl ctrlSetBackgroundColor [profilenamespace getvariable ['GUI_BCG_RGB_R',0.13],profilenamespace getvariable ['GUI_BCG_RGB_G',0.54],profilenamespace getvariable ['GUI_BCG_RGB_B',0.21],profilenamespace getvariable ['GUI_BCG_RGB_A',0.8]];
    _titleCtrl ctrlSetText _title;
    _titleCtrl ctrlCommit 0;

    private _bgCtrl = _display ctrlCreate ["RscBackground",-1];
    _bgCtrl ctrlSetPosition [TOTAL_X,BACKGROUND_Y,TOTAL_W,BACKGROUND_H];
    _bgCtrl ctrlSetBackgroundColor BACKGROUND_COLOR;
    _bgCtrl ctrlCommit 0;

    _cgCtrl = _display ctrlCreate ["RscControlsGroupNoHScrollbars",-1];
    _cgCtrl ctrlSetPosition [TOTAL_X,BACKGROUND_Y,TOTAL_W,BACKGROUND_H];
    _cgCtrl ctrlCommit 0;

    _textCtrl = _display ctrlCreate ["RscStructuredText",-1,_cgCtrl];
    _textCtrl ctrlSetStructuredText parseText (_textArray joinString "<br/>");
    _textCtrl ctrlSetPosition [0,0,TOTAL_W,(ctrlTextHeight _textCtrl) * 0.10];
    _textCtrl ctrlCommit 0;
};

// MAIN ========================================================================
systemChat "grad-loadout verifier: checking loadouts";

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

private _displayText = [];

diag_log "GRAD-LOADOUT VERIFICATION REPORT =====================================";
diag_log format ["%1 loadouts checked",_verifiedLoadoutCount];
diag_log format ["%1 errors, %2 warnings",count _errorLog,count _warningLog];
{
    _logType = ["ERROR","WARNING"] select _forEachIndex;
    {
        _x params ["_message","_unit"];
        _log = format ["%1: %2 - %3 (%4)",_logType,_message,_unit,[_unit] call _fnc_getRoleDescription];
        diag_log _log;
        _displayText pushBack _log;
    } forEach _x;
} forEach [_errorLog,_warningLog];
diag_log "======================================================================";

systemChat format ["grad-loadout verifier: %1 loadouts checked",_verifiedLoadoutCount];
systemChat format ["grad-loadout verifier: %1 errors, %2 warnings",count _errorLog,count _warningLog];
if (count _errorLog > 0 || count _warningLog > 0) then {systemChat "grad-loadout verifier: see rpt file for results"};

[_displayText,format ["GRAD-LOADOUT VERIFIER  -  %1 ERRORS, %2 WARNINGS",count _errorLog,count _warningLog]] call _fnc_errorDisplay;
